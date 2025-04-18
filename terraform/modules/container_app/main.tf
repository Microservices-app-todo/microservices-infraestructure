resource "azurerm_container_app" "this" {
  name                         = var.container_app_name
  resource_group_name          = var.resource_group_name
  container_app_environment_id = var.container_app_environment_id
  revision_mode                = "Single"

  registry {
    server   = var.acr_login_server
    identity = var.identity_id
  }

  ingress {
    external_enabled           = var.ingress_enabled
    allow_insecure_connections = true
    target_port                = var.target_port
    transport                  = var.is_tcp ? "tcp" : "auto"

    dynamic "exposed_port" {
      for_each = var.is_tcp ? [1] : []
      content {
        exposed_port = var.target_port
      }
    }

    traffic_weight {
      percentage      = 100
      latest_revision = true
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

  lifecycle {
    ignore_changes = [
      template[0].container[0].image
    ]
  }


  identity {
    type         = "UserAssigned"
    identity_ids = [var.identity_id]
  }
}
