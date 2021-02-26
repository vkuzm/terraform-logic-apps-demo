terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.49.0"
    }
  }
}

provider "azurerm" {
  features {}

  #client_id       = "" #ARM_CLIENT_ID
  #client_secret   = "" #ARM_CLIENT_SECRET
  #subscription_id = "" #ARM_SUBSCRIPTION_ID
  #tenant_id       = "" #ARM_TENANT_ID
}
