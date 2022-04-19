provider "azurerm" {
  features {}
  subscription_id = "b2d3029d-a6ac-4690-b005-312bba3a7639" #subscription ID
  client_id       = "129b5913-a8e3-4fd5-8f41-f3e2a2547f63" #appID
  client_secret   = "ej3MhK1xUFK9C-YCo370w1HeTCuibFQECV" #password
  tenant_id       = "cea297cb-9bde-428d-9a6e-48fa9c582ed6" #tenant
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
