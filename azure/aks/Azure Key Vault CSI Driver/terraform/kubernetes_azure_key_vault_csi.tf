resource "helm_release" "csi_secrets_store_provider_azure" {
  name       = "csi-secrets-store-provider-azure"
  repository = "https://raw.githubusercontent.com/Azure/secrets-store-csi-driver-provider-azure/master/charts"
  chart      = "csi-secrets-store-provider-azure"
  version    = "0.2.0"
  namespace  = "kube-system"
}
