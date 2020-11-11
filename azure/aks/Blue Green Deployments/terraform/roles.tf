resource "azurerm_role_assignment" "aks_network_contributor_blue" {
  scope                = azurerm_resource_group.default.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.blue.identity.0.principal_id
}

resource "azurerm_role_assignment" "aks_network_contributor_green" {
  scope                = azurerm_resource_group.default.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.green.identity.0.principal_id
}
