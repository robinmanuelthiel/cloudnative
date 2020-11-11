resource "kubernetes_namespace" "api_internal" {
  metadata {
    name = "api-internal"
  }
}

resource "kubernetes_pod" "api_internal" {
  metadata {
    name      = "api"
    namespace = kubernetes_namespace.api_internal.metadata[0].name

    labels = {
      app = "api"
    }
  }

  spec {
    container {
      image = "robinmanuelthiel/microcommunication-api:latest"
      name  = "api"

      port {
        container_port = 8080
      }
    }
  }
}

resource "kubernetes_service" "api_internal" {
  metadata {
    name      = "api"
    namespace = kubernetes_namespace.api_internal.metadata[0].name

    annotations = {
      "service.beta.kubernetes.io/azure-load-balancer-internal" = "true"
    }
  }

  spec {
    selector = {
      app = kubernetes_pod.api_internal.metadata.0.labels.app
    }

    port {
      port        = 80
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}
