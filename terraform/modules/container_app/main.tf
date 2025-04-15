resource "azurerm_container_app" "this" {
  name                         = var.container_app_name
  resource_group_name          = var.resource_group_name
  container_app_environment_id = var.container_app_environment_id
  revision_mode                = "Single"

  template {

    container {
      name   = var.container_name
      image  = var.container_image
      cpu    = var.cpu
      memory = var.memory
      
      dynamic "env" {
        for_each = var.env_variables
        content {
          name  = env.key
          value = env.value
        }
      }
    }
  }

  registry {
    server   = var.acr_login_server
    identity = var.identity_id
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [var.identity_id]
  }
}