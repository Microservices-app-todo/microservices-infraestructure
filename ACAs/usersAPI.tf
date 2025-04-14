resource "azurerm_container_app" "usersAPI_aca" {
  name                         = "microservicio1"
  container_app_environment_id = azurerm_container_app_environment.aca_env.id
  resource_group_name          = azurerm_resource_group.microservices_rg.name
  revision_mode                = "Single"

  registry {
    server               = azurerm_container_registry.acr.login_server
    username             = azurerm_container_registry.acr.admin_username
    password_secret_ref  = "acr-password"
  }

  secret {
    name  = "acr-password"
    value = azurerm_container_registry.acr.admin_password
  }

  template {
    container {
      name   = "microservicio1"
      image  = "${azurerm_container_registry.acr.login_server}/microservicio1:latest"
      cpu    = 0.5
      memory = "1.0Gi"
    }
  }
}
