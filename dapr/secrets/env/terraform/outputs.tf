output "aad_pod_identity_resource_id" {
  value       = azurerm_user_assigned_identity.pod_identity.id
  description = "Resource ID for the Managed Identity for AAD Pod Identity"
}

output "aad_pod_identity_client_id" {
  value       = azurerm_user_assigned_identity.pod_identity.client_id
  description = "Client ID for the Managed Identity for AAD Pod Identity"
}
