# Create virtual network
resource "azurerm_virtual_network" "mvnet_demo" {
    name                = "vnet-${var.namespace}-demo"
    address_space       = var.address_space
    location            = var.location
    resource_group_name = var.rg_name
 
    tags = {
        environment = "Terraform Demo"
    }
}
 
# Create subnet
resource "azurerm_subnet" "myterraformsubnet" {
    name                 = "subnet-${var.namespace}-demo"
    resource_group_name  = var.rg_name
    virtual_network_name = azurerm_virtual_network.mvnet_demo.name
    address_prefixes       = var.address_prefix
}
