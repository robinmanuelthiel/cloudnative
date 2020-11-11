resource "azurerm_virtual_network" "default" {
  name                = "vnet"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  address_space       = ["10.0.0.0/8"]
}

resource "azurerm_subnet" "appgateway" {
  name                 = "appgateway"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "aksblue" {
  name                 = "aksblue"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.2.0.0/16"]
}

resource "azurerm_subnet" "aksgreen" {
  name                 = "aksgreen"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.3.0.0/16"]
}
