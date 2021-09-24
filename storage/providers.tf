terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.78.0"
    }
  }
}
provider "azurerm" {
  features {}

  subscription_id = "d7eb1cba-f5ff-4f6d-9eca-2725372f0266"
  tenant_id       = "76a2ae5a-9f00-4f6b-95ed-5d33d77c4d61"
}
