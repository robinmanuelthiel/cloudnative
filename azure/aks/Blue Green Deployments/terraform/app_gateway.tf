resource "azurerm_application_gateway" "default" {
  name                = "appgateway"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.appgateway.id
  }

  # Frontend  
  frontend_ip_configuration {
    name                 = "frontend-ip"
    public_ip_address_id = azurerm_public_ip.app_gateway.id
  }

  frontend_port {
    name = "frontend-port"
    port = 80
  }

  # Backend Blue
  backend_address_pool {
    name         = "blue"
    ip_addresses = ["10.2.10.1"]
  }

  # Backend Green
  backend_address_pool {
    name         = "green"
    ip_addresses = ["10.3.10.1"]
  }

  # Default HTTP settings
  backend_http_settings {
    name                  = "default"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 20
  }

  # Listeners
  http_listener {
    name                           = "active-http"
    frontend_ip_configuration_name = "frontend-ip"
    frontend_port_name             = "frontend-port"
    protocol                       = "Http"
    host_name                      = "bluegreen.robinmanuelthiel.dev"
  }

  http_listener {
    name                           = "blue-http"
    frontend_ip_configuration_name = "frontend-ip"
    frontend_port_name             = "frontend-port"
    protocol                       = "Http"
    host_name                      = "blue.bluegreen.robinmanuelthiel.dev"
  }

  http_listener {
    name                           = "green-http"
    frontend_ip_configuration_name = "frontend-ip"
    frontend_port_name             = "frontend-port"
    protocol                       = "Http"
    host_name                      = "green.bluegreen.robinmanuelthiel.dev"
  }

  # Routing rules  
  request_routing_rule {
    name                       = "active"
    rule_type                  = "Basic"
    http_listener_name         = "active-http"
    backend_address_pool_name  = var.active_environment # <-- This needs to change for the switch
    backend_http_settings_name = "default"
  }

  request_routing_rule {
    name                       = "blue"
    rule_type                  = "Basic"
    http_listener_name         = "blue-http"
    backend_address_pool_name  = "blue"
    backend_http_settings_name = "default"
  }

  request_routing_rule {
    name                       = "green"
    rule_type                  = "Basic"
    http_listener_name         = "green-http"
    backend_address_pool_name  = "green"
    backend_http_settings_name = "default"
  }
}
