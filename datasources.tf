# Get storage account settings
data "azurerm_storage_account_sas" "sas" {
  connection_string = azurerm_storage_account.storage.primary_connection_string
  https_only        = true
  start             = "2019-01-01"
  expiry            = "2021-12-31"
  resource_types {
    object    = true
    container = false
    service   = false
  }
  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }
  permissions {
    read    = true
    write   = false
    delete  = false
    list    = false
    add     = false
    create  = false
    update  = false
    process = false
  }
}

# Get current subscription
data "azurerm_subscription" "current" {}

# Get logic app workflow by name
data "azurerm_logic_app_workflow" "current" {
  name                = "${var.prefix}-workflow-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
}
