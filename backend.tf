terraform {
  backend "azurerm" {
    storage_account_name = "rfqinfrastatefiles"
    container_name = "improzo-tofu-state-files"
    key = "improzo.tfstate"
    access_key = "access key here"
    
  }

}
