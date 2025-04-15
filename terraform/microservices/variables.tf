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