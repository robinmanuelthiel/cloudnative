resource "azurerm_api_management" "default" {
  name                = "${var.prefix}apim"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  publisher_name      = "My Company"
  publisher_email     = "rothie@microsoft.com"
  sku_name            = "Developer_1"

  virtual_network_type = "External"
  virtual_network_configuration {
    subnet_id = azurerm_subnet.apim.id
  }
}
