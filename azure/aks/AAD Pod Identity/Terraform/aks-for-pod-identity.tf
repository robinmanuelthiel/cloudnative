# Azure Provider
provider "azurerm" {
  version = "=2.8.0"
  features {}
}

# Current Azure Account Data Source
data "azurerm_client_config" "current" {}

variable "name" {
  default = "rothieakspodidentity"
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

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

# Managed Identity for Pod Identity
resource "azurerm_user_assigned_identity" "aks_pod_identity" {
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  name                = "${var.name}id"
}

# Role assignments
# Details: https://github.com/Azure/aad-pod-identity/blob/master/docs/readmes/README.role-assignment.md
resource "azurerm_role_assignment" "aks_identity_operator" {
  scope                = azurerm_user_assigned_identity.aks_pod_identity.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_kubernetes_cluster.default.kubelet_identity[0].object_id
}

resource "azurerm_role_assignment" "aks_vm_contributor" {
  scope = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourcegroups/${azurerm_kubernetes_cluster.default.node_resource_group}"
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = azurerm_kubernetes_cluster.default.kubelet_identity[0].object_id
}

# Outputs
output "aad_pod_identity_resource_id" {
  value       = azurerm_user_assigned_identity.aks_pod_identity.id
  description = "Resource ID for the Managed Identity for AAD Pod Identity"
}

output "aad_pod_identity_client_id" {
  value       = azurerm_user_assigned_identity.aks_pod_identity.client_id
  description = "Client ID for the Managed Identity for AAD Pod Identity"
}
