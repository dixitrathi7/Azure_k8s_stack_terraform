terraform {
  backend "azurerm" {
    storage_account_name = "rfqinfrastatefiles"
    container_name = "improzo-tofu-state-files"
    key = "improzo.tfstate"
    access_key = "3JWPHZUc67k3JR88OAjUgl6xwiRfXUYibE6ckhh8zQIl3ZD4gn+M279qaR3kWyZY1zzFwnr1NmRi+AStlE3PxA=="
    
  }
}