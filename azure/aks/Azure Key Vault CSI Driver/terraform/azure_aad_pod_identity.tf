# Managed Identity for Pod Identity
resource "azurerm_user_assigned_identity" "aks_pod_identity" {
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  name                = "${var.prefix}podid"
}
