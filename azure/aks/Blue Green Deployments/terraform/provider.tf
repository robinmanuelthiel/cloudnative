terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "> 2.27"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "1.13.2"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "kubernetes" {
  alias                  = "blue"
  load_config_file       = "false"
  username               = azurerm_kubernetes_cluster.blue.kube_config.0.username
  password               = azurerm_kubernetes_cluster.blue.kube_config.0.password
  host                   = azurerm_kubernetes_cluster.blue.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.blue.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.blue.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.blue.kube_config.0.cluster_ca_certificate)
}

provider "kubernetes" {
  alias                  = "green"
  load_config_file       = "false"
  password               = azurerm_kubernetes_cluster.green.kube_config.0.password
  host                   = azurerm_kubernetes_cluster.green.kube_config.0.host
  username               = azurerm_kubernetes_cluster.green.kube_config.0.username
  client_certificate     = base64decode(azurerm_kubernetes_cluster.green.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.green.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.green.kube_config.0.cluster_ca_certificate)
}
