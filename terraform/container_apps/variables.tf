variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "microservices-rg"
}

variable "container_app_environment_id" {
  description = "ID of the Azure Container App Environment"
  type        = string
}

variable "identity_id" {
  description = "ID of the User Assigned Managed Identity"
  type        = string
}

variable "acr_login_server" {
  description = "Login server URL of the Azure Container Registry"
  type        = string
}