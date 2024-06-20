terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "storagefortfstatebackend" //
    container_name       = "tfstate"
    key                  = "AzMonitor.terraform.tfstate"
  }
}
