terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "tfstatemetricaprod"
    container_name       = "terraform-state"
    key                  = "prod.terraform.tfstate"
  }
}
