output "puppet_server_fqdn" {
  value = var.puppet_server_fqdn
}

output "vm_private_ips" {
  value = { for k, nic in azurerm_network_interface.vm : k => nic.private_ip_address }
}

output "bastion_fqdn" {
  value = azurerm_bastion_host.main.dns_name
}

output "appgw_public_ip" {
  value = azurerm_public_ip.appgw.ip_address
}