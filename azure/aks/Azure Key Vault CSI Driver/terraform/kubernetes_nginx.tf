resource "helm_release" "nginx" {
  name       = "nginx"
  namespace  = "default"
  repository = "https://charts.helm.sh/stable"
  chart      = "nginx-ingress"
  version    = "1.41.3"

  set {
    name  = "controller.replicaCount"
    value = "1"
  }

  set {
    name  = "controller.nodeSelector.beta\\.kubernetes\\.io/os"
    value = "linux"
    type  = "string"
  }

  set {
    name  = "defaultBackend.nodeSelector.beta\\.kubernetes\\.io/os"
    value = "linux"
    type  = "string"
  }

  set {
    name  = "controller.service.loadBalancerIP"
    value = azurerm_public_ip.default.ip_address
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io\\/azure-load-balancer-resource-group"
    value = azurerm_resource_group.default.name
    type  = "string"
  }


  # NGINX Config according to https://azure.github.io/secrets-store-csi-driver-provider-azure/configurations/ingress-tls/#bind-certificate-to-ingress

  set {
    name  = "controller.podLabels.aadpodidbinding"
    value = "demo-aad-pod-identity"
    type  = "string"
  }

  set {
    name  = "controller.extraVolumes[0].name"
    value = "secrets-store-inline"
    type  = "string"
  }

  set {
    name  = "controller.extraVolumes[0].csi.driver"
    value = "secrets-store.csi.k8s.io"
    type  = "string"
  }

  set {
    name  = "controller.extraVolumes[0].csi.readOnly"
    value = true
  }

  set {
    name  = "controller.extraVolumes[0].csi.volumeAttributes.secretProviderClass"
    value = "demo-azure-keyvault-cert"
    type  = "string"
  }

  set {
    name  = "controller.extraVolumeMounts[0].name"
    value = "secrets-store-inline"
    type  = "string"
  }

  set {
    name  = "controller.extraVolumeMounts[0].mountPath"
    value = "/mnt/secrets-store"
    type  = "string"
  }

  set {
    name  = "controller.extraVolumeMounts[0].readOnly"
    value = true
  }
}
