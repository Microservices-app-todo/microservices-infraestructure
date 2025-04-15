resource "azurerm_role_assignment" "acr_pull_permission" {
  principal_id         = azurerm_user_assigned_identity.aca_identity.principal_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.microservices_acr.id
}