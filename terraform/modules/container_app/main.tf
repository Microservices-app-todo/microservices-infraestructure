resource "azurerm_container_app" "this" {
  name                         = var.container_app_name
  resource_group_name          = var.resource_group_name
  container_app_environment_id = var.container_app_environment_id
  revision_mode                = "Single"

  registry {
    server   = var.acr_login_server
    identity = var.identity_id
  }

  dynamic "ingress" {
    for_each = var.ingress_enabled ? [1] : []
    content {
      external_enabled = true
      target_port      = var.target_port
      transport        = "auto"
      traffic_weight {
        percentage = 100
      }
    }
  }

  template {
    min_replicas = 1
    max_replicas = 10
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



  identity {
    type         = "UserAssigned"
    identity_ids = [var.identity_id]
  }



}
