resource "azurerm_subnet" "subnet1" {
    name = "subnet1"
    resource_group_name = "${azurerm_resource_group.my_resource_group.name}"
    virtual_network_name = "${azurerm_virtual_network.AzureVnet.name}"
    address_prefix = "10.0.1.0/24"
}


# creation du Network security group

resource "azurerm_network_security_group" "myFirstNSG1" {
    name = "myNG1"
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

     security_rule {

        name                       = "jenkins"
        priority                   = 1004
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "8080"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
        
    }
}

# creation d'une adresse IP Public

resource "azurerm_public_ip" "myFirstIP1" {
    name                         = "testPublicIP1"
    location                     = "${var.location}"
    resource_group_name          = "${azurerm_resource_group.my_resource_group.name}"
    allocation_method            = "Dynamic"
    
}

# création d'une carte reseau   

resource "azurerm_network_interface" "myFirstNIC1" {
    name                      = "testNIC1"
    location                  = "${var.location}"
    resource_group_name       = "${azurerm_resource_group.my_resource_group.name}"
    network_security_group_id = "${azurerm_network_security_group.myFirstNSG1.id}"   

    ip_configuration {
        name                          = "testNICConfig"
        subnet_id                     = "${azurerm_subnet.subnet1.id}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = "${azurerm_public_ip.myFirstIP1.id}"
    }
}

# création d'une VM

resource "azurerm_virtual_machine" "myFirstVM1" {

        name                  = "testVM1"
        location              = "${var.location}"
        resource_group_name   = "${azurerm_resource_group.my_resource_group.name}"
        network_interface_ids = ["${azurerm_network_interface.myFirstNIC1.id}"]
        vm_size               = "Standard_B1s"

        storage_os_disk {
            name              = "myOsDisk1"
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
            computer_name  = "MounaVM1"
            admin_username = "Mounabal1"

        }

        os_profile_linux_config {
            disable_password_authentication = true
            ssh_keys {
                path     = "/home/Mounabal1/.ssh/authorized_keys"
                key_data = "${var.key_data}"

        }

    }
    
}

