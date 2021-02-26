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

  client_id       = "f44b9ec4-bed5-4e1a-bd10-144412d29671" #ARM_CLIENT_ID
  client_secret   = "U78b~GO~bAgkKsGA_Re6foGQ4AuqeFn959"   #ARM_CLIENT_SECRET
  subscription_id = "933e0a01-556c-4460-980c-9242afdfbb80" #ARM_SUBSCRIPTION_ID
  tenant_id       = "03209376-6a0a-46bb-a1c2-dcb357945e7f" #ARM_TENANT_ID
}