resource "azurerm_container_registry_task" "build_usersAPI.tf" {
  name                  = "build-usersAPI"
  container_registry_id = azurerm_container_registry.acr.id
  location              = azurerm_container_registry.acr.location
  platform {
    os = "Linux"
  }

  docker_step {
    dockerfile_path      = "Dockerfile"
    context_path         = var.github_repo_url
    context_access_token = var.github_access_token
    image_names          = ["usersAPI:latest"]
    is_push_enabled      = true
  }

  trigger {
    source_trigger_enabled = false
    base_image_trigger {
      name                     = "base-image-trigger"
      base_image_trigger_type  = "Runtime"
    }
  }
}
