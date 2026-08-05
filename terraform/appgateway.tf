resource "azurerm_public_ip" "appgw" {

  name                = local.appgw_public_ip_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  allocation_method = "Static"
  sku               = "Standard"

  tags = local.tags
}

resource "azurerm_application_gateway" "main" {

  name                = local.appgw_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  sku {
    name     = local.appgw_sku_name
    tier     = local.appgw_sku_tier
    capacity = local.appgw_capacity
  }

  gateway_ip_configuration {
    name      = local.appgw_gateway_ip_config_name
    subnet_id = azurerm_subnet.appgw.id
  }

  frontend_ip_configuration {
    name                 = local.appgw_frontend_ip_name
    public_ip_address_id = azurerm_public_ip.appgw.id
  }

  frontend_port {
    name = local.appgw_frontend_port_name
    port = local.appgw_frontend_port
  }

  backend_address_pool {
    name = local.appgw_backend_pool_name

    ip_addresses = [
      for key, nic in azurerm_network_interface.vm :
      nic.private_ip_address
      if local.vms[key].role == "app"
    ]
  }

  backend_http_settings {
    name = local.appgw_http_settings_name

    protocol = "Http"

    port = 80

    cookie_based_affinity = "Disabled"

    request_timeout = 30

    probe_name = local.appgw_probe_name
  }

  probe {

    name = local.appgw_probe_name

    protocol = "Http"

    path = local.probe_path

    interval = local.probe_interval

    timeout = local.probe_timeout

    unhealthy_threshold = local.probe_unhealthy_threshold

    host = "127.0.0.1"

    pick_host_name_from_backend_http_settings = false
  }

  http_listener {

    name = local.appgw_listener_name

    frontend_ip_configuration_name = local.appgw_frontend_ip_name

    frontend_port_name = local.appgw_frontend_port_name

    protocol = "Http"
  }

  request_routing_rule {

    name = local.appgw_rule_name

    priority = 100

    rule_type = "Basic"

    http_listener_name = local.appgw_listener_name

    backend_address_pool_name = local.appgw_backend_pool_name

    backend_http_settings_name = local.appgw_http_settings_name
  }

  tags = local.tags
}