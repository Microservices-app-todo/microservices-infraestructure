output "azurerm_container_app_url" {
  value = "https://${azurerm_container_app.this.ingress.fqdn}"
}
