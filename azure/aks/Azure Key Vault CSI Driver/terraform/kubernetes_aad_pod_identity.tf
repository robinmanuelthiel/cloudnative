resource "helm_release" "aad_pod_identity" {
  name       = "aad-pod-identity"
  repository = "https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts"
  chart      = "aad-pod-identity"
  version    = "4.1.4"

  set {
    name  = "azureIdentities.demo.name"
    value = "demo-aad-pod-identity"
  }

  set {
    name  = "azureIdentities.demo.type"
    value = 0
  }

  set {
    name  = "azureIdentities.demo.resourceID"
    value = azurerm_user_assigned_identity.aks_pod_identity.id
  }

  set {
    name  = "azureIdentities.demo.clientID"
    value = azurerm_user_assigned_identity.aks_pod_identity.client_id
  }

  set {
    name  = "azureIdentities.demo.binding.name"
    value = "demo-aad-pod-identity-binding"
  }

  set {
    name  = "azureIdentities.demo.binding.selector"
    value = "demo-aad-pod-identity"
  }
}
