variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
}

variable "client_secret" {
  description = "Azure client secret"
  type        = string
}

variable "client_id" {
  description = "Azure client ID"
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