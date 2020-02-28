# création du resource_group

resource "azurerm_resource_group" "my_resource_group" {
    name = "${var.nameRG}"
    location = "${var.location}" 
}

# création du Azure Vnet 

resource "azurerm_virtual_network" "AzureVnet" {
    name = "${var.nameVnet}" 
    address_space = [ "10.0.0.0/16" ]
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.my_resource_group.name}"
    
}


    
    
    




