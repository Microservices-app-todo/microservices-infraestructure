module "aca_apps" {
  source = "../modules/container_app"
  for_each = {

    nginx = {
      container_app_name = "nginx"
      container_name     = "nginx"
      image              = "${var.acr_login_server}/nginx:latest"
      cpu                = 0.5
      memory             = "1.0Gi"
      env_variables      = {}
    }

    zipkin = {
      container_app_name = "zipkin"
      container_name     = "zipkin"
      image              = "${var.acr_login_server}/zipkin:latest"
      cpu                = 0.5
      memory             = "1.0Gi"
      env_variables      = {}
    }

    redis = {
      container_app_name = "redis"
      container_name     = "redis"
      image              = "redis:7.2-alpine"
      cpu                = 0.5
      memory             = "1.0Gi"
      env_variables      = {}
    }

    users = {
      container_app_name = "users-api"
      container_name     = "users-api"
      image              = "${var.acr_login_server}/nginx:latest"
      cpu                = 0.5
      memory             = "1.0Gi"
      env_variables = {
        "JWT_SECRET"  = "PRFT"
        "SERVER_PORT" = "8083"
        "ZIPKIN_URL"  = "http://zipkin:9411"
      }
    }
    auth = {
      container_app_name = "auth-api"
      container_name     = "auth-api"
      image              = "${var.acr_login_server}/nginx:latest"
      cpu                = 0.5
      memory             = "1.0Gi"
      env_variables = {
        "JWT_SECRET"        = "PRFT"
        "AUTH_API_PORT"     = "8000"
        "USERS_API_ADDRESS" = "http://users-api:8083"
        "ZIPKIN_URL"        = "http://zipkin:9411"
      }
    }
    todos = {
      container_app_name = "todos-api"
      container_name     = "todos-api"
      image              = "${var.acr_login_server}/nginx:latest"
      cpu                = 0.5
      memory             = "1.0Gi"
      env_variables = {
        "JWT_SECRET"    = "PRFT"
        "TODO_API_PORT" = "8082"
        "REDIS_HOST"    = "redis"
        "REDIS_PORT"    = "6379"
        "REDIS_CHANNEL" = "log_channel"
        "ZIPKIN_URL"    = "http://zipkin:9411"
      }
    }
    log_processor = {
      container_app_name = "log-processor"
      container_name     = "log-processor"
      image              = "${var.acr_login_server}/nginx:latest"
      cpu                = 0.5
      memory             = "1.0Gi"
      env_variables = {
        "REDIS_HOST"    = "redis"
        "REDIS_PORT"    = "6379"
        "REDIS_CHANNEL" = "log_channel"
        "ZIPKIN_URL"    = "http://zipkin:9411"
      }
    }
    frontend = {
      container_app_name = "frontend"
      container_name     = "frontend"
      image              = "${var.acr_login_server}/nginx:latest"
      cpu                = 0.5
      memory             = "1.0Gi"
      env_variables = {
        "PORT"              = "8080"
        "AUTH_API_ADDRESS"  = "http://auth-api:8000"
        "TODOS_API_ADDRESS" = "http://todos-api:8082"
        "ZIPKIN_URL"        = "http://zipkin:9411"
      }
    }
  }

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
    bucket         = "terraform-state-bucket-microservices"
    key            = "container_apps/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
