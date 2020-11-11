resource "azurerm_public_ip" "app_gateway" {
  name                = "applicationgateway"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  sku                 = "Standard"
  allocation_method   = "Static"
}
