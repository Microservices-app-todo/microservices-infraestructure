module "aca_apps" {
  source = "../modules/container_app"
  for_each = {

    proxy-api = {
      container_app_name = "proxy-api"
      container_name     = "proxy-api"
      image              = "${var.acr_login_server}/proxy-api:latest"
      cpu                = 0.5
      memory             = "1.0Gi"
      env_variables = {
        "REDIS_HOST" = "redis-gatekeeper"
        "REDIS_PORT" = "6379"
      }
      ingress_enabled = true
      target_port     = 8085
      is_tcp          = false
    }

    zipkin = {
      container_app_name = "zipkin"
      container_name     = "zipkin"
      image              = "openzipkin/zipkin:latest"
      cpu                = 0.5
      memory             = "1.0Gi"
      env_variables      = {}
      ingress_enabled    = false
      target_port        = 9411
      is_tcp             = false

    }

    redis = {
      container_app_name = "redis"
      container_name     = "redis"
      image              = "redis:7.0-alpine"
      cpu                = 0.5
      memory             = "1.0Gi"
      env_variables      = {}
      ingress_enabled    = false
      target_port        = 6379
      is_tcp             = true
    }

    redis-gatekeeper = {
      container_app_name = "redis-gatekeeper"
      container_name     = "redis-gatekeeper"
      image              = "redis:7.0-alpine"
      cpu                = 0.5
      memory             = "1.0Gi"
      env_variables      = {}
      ingress_enabled    = false
      target_port        = 6379
      is_tcp             = true
    }


    redis-gatekeeper-two = {
      container_app_name = "redis-gatekeeper-two"
      container_name     = "redis-gatekeeper-two"
      image              = "redis:7.0-alpine"
      cpu                = 0.5
      memory             = "1.0Gi"
      env_variables      = {}
      ingress_enabled    = false
      target_port        = 6379
      is_tcp             = true
    }

    users-api = {
      container_app_name = "users-api"
      container_name     = "users-api"
      image              = "${var.acr_login_server}/users-api:latest"
      cpu                = 0.5
      memory             = "1.0Gi"
      env_variables = {
        "JWT_SECRET"  = "PRFT"
        "SERVER_PORT" = "8083"
        "ZIPKIN_URL"  = "http://zipkin:80"
      }
      ingress_enabled = false
      target_port     = 8083
      is_tcp          = false
    }
    auth-api = {
      container_app_name = "auth-api"
      container_name     = "auth-api"
      image              = "${var.acr_login_server}/auth-api:latest"
      cpu                = 0.5
      memory             = "1.0Gi"
      env_variables = {
        "JWT_SECRET"        = "PRFT"
        "AUTH_API_PORT"     = "8000"
        "USERS_API_ADDRESS" = "http://users-api:80"
        "ZIPKIN_URL"        = "http://zipkin:80"
      }
      ingress_enabled = false
      target_port     = 8000
      is_tcp          = false
    }
    todos-api = {
      container_app_name = "todos-api"
      container_name     = "todos-api"
      image              = "${var.acr_login_server}/todos-api:latest"
      cpu                = 0.5
      memory             = "1.0Gi"
      env_variables = {
        "JWT_SECRET"    = "PRFT"
        "TODO_API_PORT" = "8082"
        "REDIS_HOST"    = "redis"
        "REDIS_PORT"    = "6379"
        "REDIS_CHANNEL" = "log_channel"
        "ZIPKIN_URL"    = "http://zipkin:80"
      }
      ingress_enabled = false
      target_port     = 8082
      is_tcp          = false
    }
    log_processor = {
      container_app_name = "log-processor"
      container_name     = "log-processor"
      image              = "${var.acr_login_server}/log-message-processor:latest"
      cpu                = 0.5
      memory             = "1.0Gi"
      env_variables = {
        "REDIS_HOST"    = "redis"
        "REDIS_PORT"    = "6379"
        "REDIS_CHANNEL" = "log_channel"
        "ZIPKIN_URL"    = "http://zipkin:80"
      }
      ingress_enabled = false
      target_port     = 80
      is_tcp          = false
    }
    frontend = {
      container_app_name = "frontend"
      container_name     = "frontend"
      image              = "${var.acr_login_server}/frontend:latest"
      cpu                = 0.5
      memory             = "1.0Gi"
      env_variables = {
        "PORT"              = "8080"
        "AUTH_API_ADDRESS"  = "http://auth-api:80"
        "TODOS_API_ADDRESS" = "http://todos-api:80"
        "ZIPKIN_URL"        = "http://zipkin:80"
      }
      ingress_enabled = true
      target_port     = 8080
      is_tcp          = false
    }

  }
  is_tcp                       = lookup(each.value, "is_tcp", false)
  ingress_enabled              = lookup(each.value, "ingress_enabled", false)
  target_port                  = lookup(each.value, "target_port", 80)
  subscription_id              = var.subscription_id
  container_app_name           = each.value.container_app_name
  container_app_environment_id = var.container_app_environment_id
  container_name               = each.value.container_name
  container_image              = each.value.image
  cpu                          = each.value.cpu
  memory                       = each.value.memory
  acr_login_server             = var.acr_login_server
  identity_id                  = var.identity_id
  env_variables                = each.value.env_variables
}

output "container_app_urls" {
  value = {
    for app_name, app in module.aca_apps :
    app_name => app.azurerm_container_app_url
  }
}

terraform {
  backend "s3" {
    bucket  = "terraform-state-bucket-microservices"
    key     = "container_apps/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
