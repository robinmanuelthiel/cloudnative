resource "azurerm_kubernetes_cluster" "default" {
  name                = "aks"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  dns_prefix          = "aks"
  kubernetes_version  = "1.18.8"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control {
    enabled = true
    azure_active_directory {
      managed = true
    }
  }




  addon_profile {
    kube_dashboard {
      enabled = false
    }
  }
}

resource "kubernetes_pod" "api" {
  metadata {
    name = "api"
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
