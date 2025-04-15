resource "azurerm_user_assigned_identity" "aca_identity" {
  name                = "aca-identity"
  resource_group_name = azurerm_resource_group.microservices_rg.name
  location            = azurerm_resource_group.microservices_rg.location
}