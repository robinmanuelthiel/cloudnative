# Outputs
output "aad_pod_identity_resource_id" {
  value       = azurerm_user_assigned_identity.aks_pod_identity.id
  description = "Resource ID for the Managed Identity for AAD Pod Identity"
}

output "aad_pod_identity_client_id" {
  value       = azurerm_user_assigned_identity.aks_pod_identity.client_id
  description = "Client ID for the Managed Identity for AAD Pod Identity"
}

# output "helm_values" {
#   value       = helm_release.aad_pod_identity.metadata.values
#   description = "AAD Pod Identity Helm Chart Values"
# }
