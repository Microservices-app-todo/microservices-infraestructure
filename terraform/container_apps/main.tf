module "aca_apps" {
  source = "../modules/container_app"
  for_each = {

    nginx = {
      container_app_name = "nginx"
      container_name     = "nginx"
      image              = "nginx:latest"
      cpu                = 0.5
      memory             = "1.0Gi"
      env_variables      = {}
      ingress_enabled = true
      target_port     = 80
    }

    zipkin = {
      container_app_name = "zipkin"
      container_name     = "zipkin"
      image              = "openzipkin/zipkin:latest"
      cpu                = 0.5
      memory             = "1.0Gi"
      env_variables      = {}
      ingress_enabled = true
      target_port     = 9411
    }

    redis = {
      container_app_name = "redis"
      container_name     = "redis"
      image              = "redis:7.2-alpine"
      cpu                = 0.5
      memory             = "1.0Gi"
      env_variables      = {}
      ingress_enabled = true
      target_port     = 6379
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
      ingress_enabled = true
      target_port     = 8083
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
      ingress_enabled = true
      target_port     = 8000
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
      ingress_enabled = true
      target_port     = 8082
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
      ingress_enabled = true
      target_port     = 80

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
    }

    debugger = {
      container_app_name = "debugger"
      container_name     = "debugger"
      image              = "curlimages/curl:latest"
      cpu                = 0.25
      memory             = "0.5Gi"
      env_variables      = {}
      ingress_enabled    = true
    }
  }
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



terraform {
  backend "s3" {
    bucket  = "terraform-state-bucket-microservices"
    key     = "container_apps/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
