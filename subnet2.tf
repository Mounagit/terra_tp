resource "azurerm_subnet" "subnet2" {
    name = "subnet2"
    resource_group_name = "${azurerm_resource_group.my_resource_group.name}"
    virtual_network_name = "${azurerm_virtual_network.AzureVnet.name}"
    address_prefix = "10.0.2.0/24"

}


# creation du Network security group

resource "azurerm_network_security_group" "myFirstNSG2" {
    name = "myNG2"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.my_resource_group.name}"
    
    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"

    }

    security_rule {

        name                       = "HTTP"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"

    }


    security_rule {

        name                       = "HTTPS"
        priority                   = 1003
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"

    }
        
    }



# creation d'une adresse IP Public

resource "azurerm_public_ip" "myFirstIP2" {
    name                         = "testPublicIP2"
    location                     = "${var.location}"
    resource_group_name          = "${azurerm_resource_group.my_resource_group.name}"
    allocation_method            = "Dynamic"
    
}

# création d'une carte reseau   

resource "azurerm_network_interface" "myFirstNIC2" {
    name                      = "testNIC2"
    location                  = "${var.location}"
    resource_group_name       = "${azurerm_resource_group.my_resource_group.name}"
    network_security_group_id = "${azurerm_network_security_group.myFirstNSG2.id}"   

    ip_configuration {
        name                          = "testNICConfig"
        subnet_id                     = "${azurerm_subnet.subnet2.id}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = "${azurerm_public_ip.myFirstIP2.id}"
    }

}

# création d'une VM

resource "azurerm_virtual_machine" "myFirstVM2" {

        name                  = "testVM2"
        location              = "${var.location}"
        resource_group_name   = "${azurerm_resource_group.my_resource_group.name}"
        network_interface_ids = ["${azurerm_network_interface.myFirstNIC2.id}"]
        vm_size               = "Standard_B1s"

        storage_os_disk {
            name              = "myOsDisk2"
            caching           = "ReadWrite"
            create_option     = "FromImage"
            managed_disk_type = "Standard_LRS"

    }
        storage_image_reference {
            publisher = "OpenLogic"
            offer     = "CentOS"
            sku       = "7.6"
            version   = "latest"

        }
        
        os_profile {
            computer_name  = "MounaVM2"
            admin_username = "Mounabal2"
        }

        os_profile_linux_config {
            disable_password_authentication = true
            ssh_keys {
                path     = "/home/Mounabal2/.ssh/authorized_keys"
                key_data = "${var.key_data}"

        }

    }
    
}

