output "acr_login_server" {
  description = "Login server URL of the Azure Container Registry"
  value       = azurerm_container_registry.microservices_acr.login_server
}

output "identity_id" {
  description = "User Assigned Identity ID"
  value       = azurerm_user_assigned_identity.aca_identity.id
}

output "container_app_environment_id" {
  description = "The Container App Environment ID"
  value       = azurerm_container_app_environment.env.id
}

output "resource_group_name" {
  description = "The Resource Group Name"
  value       = azurerm_resource_group.microservices_rg.name
}

output "acr_name" {
  description = "Name of the Azure Container Registry"
  value       = azurerm_container_registry.microservices_acr.name
}