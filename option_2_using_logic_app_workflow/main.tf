
# Generate random string for storage name
resource "random_string" "storage_name" {
  length  = 24
  upper   = false
  lower   = true
  number  = true
  special = false
}

# Create resource group for logic app
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-${var.environment}"
  location = var.location
}

# Create strorage account
resource "azurerm_storage_account" "storage" {
  name                     = random_string.storage_name.result
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create storage container to store deployment files
resource "azurerm_storage_container" "deployments" {
  name                  = "function-releases"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

# Function 1 app code storage
resource "azurerm_storage_blob" "function1_app_code" {
  name                   = "function1_app_code.zip"
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = azurerm_storage_container.deployments.name
  type                   = "Block"
  source                 = var.function1_app_code
}

# Function 2 app code storage
resource "azurerm_storage_blob" "function2_app_code" {
  name                   = "function2_app_code.zip"
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = azurerm_storage_container.deployments.name
  type                   = "Block"
  source                 = var.function2_app_code
}

# Create application services plan for functions
resource "azurerm_app_service_plan" "asp" {
  name                = "${var.prefix}-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  kind                = "FunctionApp"

  sku {
    tier = "Standard"
    size = "S1"
  }
}

# Create function 1
resource "azurerm_function_app" "function1" {
  name                       = "${var.prefix}-function1-${var.environment}"
  location                   = var.location
  resource_group_name        = azurerm_resource_group.rg.name
  app_service_plan_id        = azurerm_app_service_plan.asp.id
  storage_account_name       = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key
  version                    = "~2"

  app_settings = {
    https_only                   = true
    FUNCTIONS_WORKER_RUNTIME     = "node"
    WEBSITE_NODE_DEFAULT_VERSION = "~10"
    FUNCTION_APP_EDIT_MODE       = "readonly"
    HASH                         = base64encode(filesha256(var.function1_app_code))
    WEBSITE_RUN_FROM_PACKAGE     = "https://${azurerm_storage_account.storage.name}.blob.core.windows.net/${azurerm_storage_container.deployments.name}/${azurerm_storage_blob.function1_app_code.name}${data.azurerm_storage_account_sas.sas.sas}"
  }
}

# Create function 2
resource "azurerm_function_app" "function2" {
  name                       = "${var.prefix}-function2-${var.environment}"
  location                   = var.location
  resource_group_name        = azurerm_resource_group.rg.name
  app_service_plan_id        = azurerm_app_service_plan.asp.id
  storage_account_name       = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key
  version                    = "~2"

  app_settings = {
    https_only                   = true
    FUNCTIONS_WORKER_RUNTIME     = "node"
    WEBSITE_NODE_DEFAULT_VERSION = "~10"
    FUNCTION_APP_EDIT_MODE       = "readonly"
    HASH                         = base64encode(filesha256(var.function2_app_code))
    WEBSITE_RUN_FROM_PACKAGE     = "https://${azurerm_storage_account.storage.name}.blob.core.windows.net/${azurerm_storage_container.deployments.name}/${azurerm_storage_blob.function2_app_code.name}${data.azurerm_storage_account_sas.sas.sas}"
  }
}

locals {
  functions_resource_group_id = "${data.azurerm_subscription.current.id}/resourceGroups/${azurerm_resource_group.rg.name}/providers/Microsoft.Web/sites"
}

resource "azurerm_logic_app_workflow" "logic_app" {
  name                = "${var.prefix}-deployment-template-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  parameters = {}
}