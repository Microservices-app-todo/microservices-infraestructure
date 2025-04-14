resource "azurerm_resource_group" "microservices_rg" {
  name     = var.microservices_resource_group_name
  location = var.microservices_location
}

resource "azurerm_resource_group" "microservices_monitoring_rg" {
  name     = var.microservices_monitoring_resource_group_name
  location = var.microservices_monitoring_location
}

resource "azurerm_resource_group" "frontend_rg" {
  name     = var.frontend_resource_group_name
  location = var.frontend_location
}