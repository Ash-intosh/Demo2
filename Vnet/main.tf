# Create virtual network
resource "azurerm_virtual_network" "mvnet_demo" {
    name                = var.virualnet_name
    address_space       = var.address_space
    location            = var.location
    resource_group_name = var.rg_name
 
    tags = {
        environment = "Terraform Demo"
    }
}
 
# Create subnet
resource "azurerm_subnet" "myterraformsubnet" {
    name                 = var.subnet_name
    resource_group_name  = var.rg_name
    virtual_network_name = azurerm_virtual_network.mvnet_demo.name
    address_prefixes       = var.address_prefix
}
