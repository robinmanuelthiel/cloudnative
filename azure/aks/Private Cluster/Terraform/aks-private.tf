# Azure Provider
provider "azurerm" {
  version = "=2.8.0"
  features {}
}

# Current Azure Account Data Source
data "azurerm_client_config" "current" {}

variable "name" {
  default = "rothieaksprivate"
  type = string
}

# Azure Resource Group
resource "azurerm_resource_group" "default" {
  name     = var.name
  location = "westeurope"
}

# Azure Kubernetes Service
resource "azurerm_kubernetes_cluster" "default" {
  name                = var.name
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  dns_prefix          = "rothietftestaks"
  private_cluster_enabled = true

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}
