resource "azurerm_key_vault" "global" {
  name                = "rothiesecretsdemoglobal"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}

# Allow AAD Pod Identity to access Azure Key Vault
resource "azurerm_key_vault_access_policy" "aks_aad_pod_identity_keyvault_access" {
  key_vault_id = azurerm_key_vault.default.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.pod_identity.principal_id

  secret_permissions = [
    "get", "list"
  ]
}

resource "azurerm_key_vault" "default" {
  name                = "rothiesecretsdemovault"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}

resource "azurerm_key_vault_secret" "test_connection_string" {
  name         = "TestConnectionString"
  value        = "Service=XY;Password=BlaBlaBla"
  key_vault_id = azurerm_key_vault.default.id
}

resource "azurerm_key_vault_secret" "test_secret" {
  name         = "TestSecret"
  value        = "Hello123"
  key_vault_id = azurerm_key_vault.default.id
}
