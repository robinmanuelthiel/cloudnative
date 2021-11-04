resource "azurerm_user_assigned_identity" "pod_identity" {
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  name                = "rothiesecretsdemoi"
}
