resource "azurerm_kubernetes_cluster" "default" {
  name                = "${var.prefix}aks"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  dns_prefix          = "${var.prefix}aks"
  kubernetes_version  = "1.20.7"

  default_node_pool {
    name           = "system"
    vm_size        = "Standard_DS2_v2"
    node_count     = 3
    vnet_subnet_id = azurerm_subnet.aks.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
  }
}
