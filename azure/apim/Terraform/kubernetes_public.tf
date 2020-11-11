resource "kubernetes_namespace" "api_public" {
  metadata {
    name = "api-public"
  }
}

resource "kubernetes_pod" "api_public" {
  metadata {
    name      = "api"
    namespace = kubernetes_namespace.api_public.metadata[0].name

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

resource "kubernetes_service" "api_public" {
  metadata {
    name      = "api"
    namespace = kubernetes_namespace.api_public.metadata[0].name
  }

  spec {
    selector = {
      app = kubernetes_pod.api_public.metadata.0.labels.app
    }

    port {
      port        = 80
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}
