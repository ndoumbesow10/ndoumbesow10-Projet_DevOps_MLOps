provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "pbdns" {
  name     = "pbdns-resources"
  location = "West Europe"
}

resource "azurerm_virtual_network" "pbdns" {
  name                = "pbdns-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.pbdns.location
  resource_group_name = azurerm_resource_group.pbdns.name
}

resource "azurerm_subnet" "pbdns" {
  name                 = "pbdns-subnet"
  resource_group_name  = azurerm_resource_group.pbdns.name
  virtual_network_name = azurerm_virtual_network.pbdns.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "pbdns" {
  name                = "pbdns-nic"
  location            = azurerm_resource_group.pbdns.location
  resource_group_name = azurerm_resource_group.pbdns.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.pbdns.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "pbdns" {
  name                  = "pbdns-machine"
  location              = azurerm_resource_group.pbdns.location
  resource_group_name   = azurerm_resource_group.pbdns.name
  network_interface_ids = [azurerm_network_interface.pbdns.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "pbdns-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "adminuser"
    admin_password = "P@ssw0rd1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_network_security_group" "pbdns" {
  name                = "pbdns-nsg"
  location            = azurerm_resource_group.pbdns.location
  resource_group_name = azurerm_resource_group.pbdns.name

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "pbdns" {
  network_interface_id      = azurerm_network_interface.pbdns.id
  network_security_group_id = azurerm_network_security_group.pbdns.id
}


resource "azurerm_virtual_machine_extension" "pbdns" {
  name                 = "pbdns"
  virtual_machine_id   = azurerm_virtual_machine.pbdns.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "fileUris": ["https://pbdnsaccount.blob.core.windows.net/pbdnscontainer/install.sh?se=2024-12-31T23%3A59%3A00Z"],
        "commandToExecute": "./install.sh"
    }
  SETTINGS
}
