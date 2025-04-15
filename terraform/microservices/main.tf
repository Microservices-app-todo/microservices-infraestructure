resource "azurerm_resource_group" "microservices_rg" {
  name     = var.resource_group_name
  location = var.location
}

terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-microservices"
    key            = "microservices/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
