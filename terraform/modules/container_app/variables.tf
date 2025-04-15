variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "microservices-rg"
}

variable "location" {
  description = "Azure region for the resources"
  type        = string
  default     = "West Europe"
}

variable "container_app_name" {
  type        = string
  description = "Name of the Azure Container App."
}

variable "container_app_environment_id" {
  type        = string
  description = "ID of the Azure Container App Environment for the Container App."
}

variable "container_name" {
  type        = string
  description = "Name of the container inside the Container App."
}

variable "container_image" {
  type        = string
  description = "Full image path in the ACR (including tag)."
}

variable "cpu" {
  type        = number
  description = "Amount of CPU assigned to the container."
}

variable "memory" {
  type        = string
  description = "Amount of RAM assigned to the container (e.g., 1.0Gi)."
}

variable "acr_login_server" {
  type        = string
  description = "Login server URL of the Azure Container Registry for the Container App."
}

variable "identity_id" {
  type        = string
  description = "ID of the User Assigned Managed Identity used to authenticate against the ACR."
}

variable "env_variables" {
  type        = map(string)
  description = "Environment variables for the container."
  default     = {}
}
