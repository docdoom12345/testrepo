provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "example"{
    name = var.rg[0]
    location = var.rg[1]
}
resource "azurerm_storage_account" "example" {
  name                     = "mystorageacc10"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}
