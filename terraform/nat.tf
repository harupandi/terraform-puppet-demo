resource "azurerm_public_ip" "nat" {
  name                = "${local.prefix}-nat-pip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  allocation_method = "Static"
  sku               = "Standard"

  tags = local.tags
}

resource "azurerm_nat_gateway" "workload" {
  name                = "${local.prefix}-natgw"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  sku_name = "Standard"

  tags = local.tags
}

resource "azurerm_nat_gateway_public_ip_association" "workload" {
  nat_gateway_id       = azurerm_nat_gateway.workload.id
  public_ip_address_id = azurerm_public_ip.nat.id
}

resource "azurerm_subnet_nat_gateway_association" "workload" {
  subnet_id      = azurerm_subnet.workload.id
  nat_gateway_id = azurerm_nat_gateway.workload.id
}