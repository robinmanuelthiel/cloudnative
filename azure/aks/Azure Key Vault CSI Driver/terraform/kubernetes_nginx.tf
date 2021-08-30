resource "helm_release" "nginx" {
  name             = "nginx"
  namespace        = "ingress"
  repository       = "https://charts.helm.sh/stable"
  chart            = "nginx-ingress"
  version          = "1.41.3"
  create_namespace = "true"

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
}
