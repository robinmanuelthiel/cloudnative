resource "helm_release" "dapr" {
  name             = "dapr"
  repository       = "https://dapr.github.io/helm-charts/"
  chart            = "dapr"
  version          = "1.4"
  namespace        = "dapr-system"
  create_namespace = "true"
}
