terraform {
  backend "azurerm" {
    resource_group_name   = "cloud-shell-storage-centralindia"
    storage_account_name  = "csg100320015b8221a2"
    container_name        = "demotstate"
    key                   = "terraform.tfstate"
  }
}
