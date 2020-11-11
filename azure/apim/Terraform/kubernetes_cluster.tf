resource "kubernetes_namespace" "api_cluster" {
  metadata {
    name = "api-cluster"
  }
}

resource "kubernetes_pod" "api_cluster" {
  metadata {
    name      = "api"
    namespace = kubernetes_namespace.api_cluster.metadata[0].name

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

resource "kubernetes_service" "api_cluster" {
  metadata {
    name      = "api"
    namespace = kubernetes_namespace.api_cluster.metadata[0].name
  }

  spec {
    selector = {
      app = kubernetes_pod.api_cluster.metadata.0.labels.app
    }

    port {
      port        = 80
      target_port = 8080
    }

    type = "ClusterIP"
  }
}
