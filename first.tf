provider "azurerm" {
  features {}
}
resource "azurerm_storage_account" "example" {
  name                     = "mystorageacc10"
  resource_group_name      = "myrg"
  location                 = "eastus"
  account_tier             = "Standard"
  account_replication_type = "GRS"
}