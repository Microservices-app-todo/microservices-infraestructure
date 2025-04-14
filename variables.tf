variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

# Microservices

variable "microservices_resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "microservices-rg"
}

variable "microservices_location" {
  description = "Azure region for the resources"
  type        = string
  default     = "West Europe"
}

# Microservices Monitoring

variable "microservices_monitoring_resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "microservices-rg"
}

variable "microservices_monitoring_location" {
  description = "Azure region for the resources"
  type        = string
  default     = "West Europe"
}

# Frontend

variable "frontend_resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "microservices-rg"
}

variable "frontend_location" {
  description = "Azure region for the resources"
  type        = string
  default     = "West Europe"
}

#
## MICROSERVICES 
#

# authAPI

variable "authAPI_github_access_token" {
  description = "authAPI Acces Token for github repo"
  type = string
}

variable "authAPI_github_repo_url" {
  description = "Github repo URL for authAPI"
  type = string
}

# LogMessageProcessor

variable "LogMessageProcessor_github_access_token" {
  description = "LogMessageProccesor Acces Token for github repo"
  type = string
}

variable "LogMessageProcessor_github_repo_url" {
  description = "Github repo URL for LogMessageProcessor"
  type = string
}

# TODOsAPI

variable "TODOsAPI_github_access_token" {
  description = "TODOsAPI Acces Token for github repo"
  type = string
}

variable "TODOsAPI_github_repo_url" {
  description = "Github repo URL for TODOsAPI"
  type = string
}

# usersAPI

variable "usersAPI_github_access_token" {
  description = "usersAPI Acces Token for github repo"
  type = string
}

variable "usersAPI_github_repo_url" {
  description = "Github repo URL for usersAPI"
  type = string
}