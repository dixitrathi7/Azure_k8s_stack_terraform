output "storage_account_host_name" {
  description = "The primary web host of the Storage Account"
  value       = azurerm_storage_account.static_storage_account.primary_web_host
}

output "storage_account_primary_web_endpoint" {
  description = "The primary web endpoint of the Storage Account"
  value       = azurerm_storage_account.static_storage_account.primary_web_endpoint
}

output "private_dns_zone" {
  description = "The private DNS zone for the Storage Account"
  value       = azurerm_private_dns_zone.private_web_dns.name
}

output "static_storage_account_id" {
  description = "The ID of the static storage account"
  value       = azurerm_storage_account.static_storage_account.id
  
}