resource "azurerm_network_interface" "vm" {

  for_each = local.vms

  name                = each.value.nic_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {

    name = "internal"

    subnet_id = azurerm_subnet.workload.id

    private_ip_address_allocation = "Dynamic"
  }

  tags = local.tags
}

resource "azurerm_linux_virtual_machine" "vm" {

  for_each = local.vms

  name                = each.value.vm_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  size = var.vm_size

  zone = each.value.zone

  admin_username = var.admin_username

  disable_password_authentication = true

  patch_mode = "AutomaticByPlatform"

  patch_assessment_mode = "AutomaticByPlatform"

  network_interface_ids = [
    azurerm_network_interface.vm[each.key].id
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }

  custom_data = base64encode(
    templatefile(
      "${path.module}/cloud_init/cloud-init.yaml.tftpl",
      {
        vm = each.value

        bootstrap_script = templatefile(
          "${path.module}/cloud_init/bootstrap-puppet.sh.tftpl",
          {
            vm = each.value

            puppet = {
              fqdn = var.puppet_server_fqdn
            }
          }
        )
      }
    )
  )

  tags = local.tags

  depends_on = [
    azurerm_private_dns_a_record.puppet,
    azurerm_subnet_nat_gateway_association.workload,
  ]

}