resource "helm_release" "aad_pod_identity" {
  name       = "aad-pod-identity"
  repository = "https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts"
  chart      = "aad-pod-identity"
  version    = "4.1.4"

  set {
    name  = "azureIdentities.default.name"
    value = "default-aad-pod-identity"
  }

  set {
    name  = "azureIdentities.default.type"
    value = 0
  }

  set {
    name  = "azureIdentities.default.resourceID"
    value = azurerm_user_assigned_identity.pod_identity.id
  }

  set {
    name  = "azureIdentities.default.clientID"
    value = azurerm_user_assigned_identity.pod_identity.client_id
  }

  set {
    name  = "azureIdentities.default.binding.name"
    value = "default-aad-pod-identity-binding"
  }

  set {
    name  = "azureIdentities.default.binding.selector"
    value = "default-aad-pod-identity"
  }

  set {
    name  = "nmi.allowNetworkPluginKubenet"
    value = "true"
  }
}
