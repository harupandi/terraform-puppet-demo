resource "azurerm_private_dns_zone" "puppet" {
  name                = "puppet.internal"
  resource_group_name = azurerm_resource_group.main.name

  tags = local.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "puppet" {
  name                  = "${local.prefix}-dns-link"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.puppet.name

  virtual_network_id = azurerm_virtual_network.main.id

  registration_enabled = false

  tags = local.tags
}

resource "azurerm_private_dns_a_record" "puppet" {
  name                = "puppet"
  zone_name           = azurerm_private_dns_zone.puppet.name
  resource_group_name = azurerm_resource_group.main.name

  ttl = 300

  records = [
    azurerm_network_interface.vm["puppet"].private_ip_address
  ]

  tags = local.tags
}