# Role assignments
# Details: https://github.com/Azure/aad-pod-identity/blob/master/docs/readmes/README.role-assignment.md
resource "azurerm_role_assignment" "pod_identity_operator" {
  role_definition_name = "Managed Identity Operator"
  scope                = azurerm_user_assigned_identity.pod_identity.id
  principal_id         = azurerm_kubernetes_cluster.default.kubelet_identity[0].object_id
}

resource "azurerm_role_assignment" "aks_vm_contributor" {
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourcegroups/${azurerm_kubernetes_cluster.default.node_resource_group}"
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = azurerm_kubernetes_cluster.default.kubelet_identity[0].object_id
}
