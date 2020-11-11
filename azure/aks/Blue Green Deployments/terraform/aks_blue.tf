resource "azurerm_kubernetes_cluster" "blue" {
  name                = "aksblue"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  dns_prefix          = "aksblue"
  kubernetes_version  = "1.18.8"

  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_D2_v2"
    vnet_subnet_id = azurerm_subnet.aksblue.id
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

resource "kubernetes_pod" "api_blue" {
  provider = kubernetes.blue

  metadata {
    name = "api-blue"
    labels = {
      app = "api"
    }
  }

  spec {
    container {
      image = "robinmanuelthiel/microcommunication-api:latest"
      name  = "api-blue"

      env {
        name  = "EnvironmentName"
        value = "blue"
      }

      port {
        container_port = 8080
      }
    }
  }
}

resource "kubernetes_service" "api_blue" {
  provider = kubernetes.blue

  metadata {
    name = "api-blue"
    annotations = {
      "service.beta.kubernetes.io/azure-load-balancer-internal" = "true"
    }
  }

  spec {
    type             = "LoadBalancer"
    load_balancer_ip = "10.2.10.1"

    selector = {
      app = kubernetes_pod.api_blue.metadata.0.labels.app
    }

    port {
      port        = 80
      target_port = 8080
    }
  }
}
