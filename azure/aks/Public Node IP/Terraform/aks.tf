resource "azurerm_kubernetes_cluster" "default" {
  name                = "aks"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  dns_prefix          = "aks"

  default_node_pool {
    name                  = "default"
    node_count            = 2
    vm_size               = "Standard_DS2_v2"
    enable_node_public_ip = true
  }

  identity {
    type = "SystemAssigned"
  }
}
