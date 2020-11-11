resource "azurerm_kubernetes_cluster" "green" {
  name                = "aksgreen"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  dns_prefix          = "aksgreen"
  kubernetes_version  = "1.18.8"

  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_D2_v2"
    vnet_subnet_id = azurerm_subnet.aksgreen.id
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control {
    enabled = true
  }

  addon_profile {
    kube_dashboard {
      enabled = false
    }

    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.default.id
    }
  }
}

resource "kubernetes_pod" "api_green" {
  provider = kubernetes.green

  metadata {
    name = "api-green"
    labels = {
      app = "api"
    }
  }

  spec {
    container {
      image = "robinmanuelthiel/microcommunication-api:latest"
      name  = "api-green"

      env {
        name  = "EnvironmentName"
        value = "green"
      }

      port {
        container_port = 8080
      }
    }
  }
}

resource "kubernetes_service" "api_green" {
  provider = kubernetes.green

  metadata {
    name = "api-green"
    annotations = {
      "service.beta.kubernetes.io/azure-load-balancer-internal" = "true"
    }
  }

  spec {
    type             = "LoadBalancer"
    load_balancer_ip = "10.3.10.1"

    selector = {
      app = kubernetes_pod.api_green.metadata.0.labels.app
    }

    port {
      port        = 80
      target_port = 8080
    }
  }
}
