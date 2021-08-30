resource "azurerm_key_vault" "default" {
  name                = "${var.prefix}vault"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}

resource "azurerm_key_vault_access_policy" "aks_env_keyvault_access" {
  key_vault_id = azurerm_key_vault.default.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.aks_pod_identity.principal_id

  secret_permissions = [
    "get", "list"
  ]

  certificate_permissions = [
    "get", "list"
  ]
}

resource "azurerm_key_vault_secret" "test_secret" {
  name         = "TestSecret"
  value        = "Hello CSI Driver"
  key_vault_id = azurerm_key_vault.default.id
}


resource "azurerm_key_vault_certificate" "test_cert" {
  name         = "TestCertificate"
  key_vault_id = azurerm_key_vault.default.id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      extended_key_usage = ["1.3.6.1.5.5.7.3.1"]

      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject            = "CN=rothiekvcsi.robinmanuelthiel.dev"
      validity_in_months = 12
    }
  }
}
