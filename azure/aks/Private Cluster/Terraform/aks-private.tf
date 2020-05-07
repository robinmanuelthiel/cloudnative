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

# Virtual Network to deploy AKS into
resource "azurerm_virtual_network" "default" {
  name                = "${var.name}vnet"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  address_space       = ["192.168.0.0/16"]

  subnet {
    name           = "AksSubnet"
    address_prefix = "192.168.1.0/24"
  }

  # Optional, for Azure Bastion only
  subnet {
    name           = "AzureBastionSubnet"
    address_prefix = "192.168.2.0/27"
  }

  # Optional, for a VM to access the Kubernetes API only
  subnet {
    name           = "VirtualMachineSubnet"
    address_prefix = "192.168.3.0/27"
  }
}

# Azure Kubernetes Service
resource "azurerm_kubernetes_cluster" "default" {
  name                = var.name
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  dns_prefix          = var.name
  private_cluster_enabled = true

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  network_profile {
    network_plugin = "kubenet"
    load_balancer_sku = "Standard"
  }

  identity {
    type = "SystemAssigned"
  }
}

# Role assignments
# Details: https://docs.microsoft.com/en-us/azure/aks/configure-kubenet
resource "azurerm_role_assignment" "aks_identity_operator" {
  scope                = azurerm_virtual_network.default.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.default.kubelet_identity[0].object_id
}
