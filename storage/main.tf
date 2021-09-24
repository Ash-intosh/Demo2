terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}
provider "azurerm" {
  features {}

  subscription_id = "d7eb1cba-f5ff-4f6d-9eca-2725372f0266"
  tenant_id       = "76a2ae5a-9f00-4f6b-95ed-5d33d77c4d61"
}

resource "random_string" "uid" {
    special = false
    upper = false
    length = 6
}

resource "azurerm_resource_group" "rg-demo" {
  name     = "rg-${var.namespace}-demo"
  location = var.location
}

resource "azurerm_storage_account" "example" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg-demo.name
  location                 = azurerm_resource_group.rg-demo.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.account_replication_type

  tags = {
    environment = var.environment
  }
}

output "resource_group_name" {
  value = azurerm_storage_account.example.resource_group_name
}
