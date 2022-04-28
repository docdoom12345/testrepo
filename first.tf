provider "azurerm" {
  features {}
}
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.97.0,<=3.3.0" #locks azurerm version
    }
  }
  required_version = ">=1.1.0" #locks terraform version
}
resource "azurerm_resource_group" "example" {
  name     = "rg-vm"
  location = "westus"
}
resource "azurerm_virtual_network" "example" {
  name                = "rg-network"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["10.0.0.0/16"]
}
resource "azurerm_subnet" "example" {
  name                 = "rg-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}
resource "azurerm_public_ip" "example" {
  name                = "publicip"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Static"
}
resource "azurerm_network_interface" "example" {
  name                = "vm-nic"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  ip_configuration {
    name                          = "ips"
    subnet_id                     = azurerm_subnet.example.id
    public_ip_address_id          = azurerm_public_ip.example.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_linux_virtual_machine" "example" {
  name                            = "linux-vm"
  resource_group_name             = azurerm_resource_group.example.name
  location                        = azurerm_resource_group.example.location
  admin_username                  = "adminuser"
  admin_password                  = "ubuntu@123"
  disable_password_authentication = false
  size                            = "Standard_DS1_v2"
  network_interface_ids           = [azurerm_network_interface.example.id]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  provisioner "remote-exec" {
    on_failure = continue #creation provisioner
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install nginx -y",
      "sudo systemctl start nginx"
    ]
  }

  connection {
    type = "ssh"
    user = self.admin_username
    password = self.admin_password
    host = self.public_ip_address
  }
}
output "publicip" {
  value = azurerm_public_ip.example.ip_address
}
