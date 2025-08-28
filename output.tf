output "rg_name_output" {
  value = azurerm_resource_group.main_rg.name
}

output "vnet_name" {
  value = azurerm_virtual_network.main_vnet.name
}

output "subnet_id" {
  value = azurerm_subnet.subnet.id
}

output "pub_ip" {
  value = azurerm_public_ip.pub_ip.ip_address
}