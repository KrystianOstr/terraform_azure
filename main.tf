
locals {
  std_prefix = lower("${var.environment}-demo")

  common_tags = {
    environment = var.environment
    owner       = var.owner
    project     = var.project
  }
}

resource "azurerm_resource_group" "main_rg" {
  name     = "${local.std_prefix}-${var.rg_name}"
  location = var.rg_location

  tags = local.common_tags
}

resource "azurerm_virtual_network" "main_vnet" {
  name                = "${local.std_prefix}-vnet"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name
  address_space       = ["10.1.0.0/16"]
  tags                = merge(local.common_tags, { role = var.networking-tag })
}

resource "azurerm_subnet" "subnet" {
  name                 = "${local.std_prefix}-subnet"
  resource_group_name  = azurerm_resource_group.main_rg.name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  address_prefixes     = ["10.1.0.0/24"]
}

resource "azurerm_public_ip" "pub_ip" {
  name                = "${local.std_prefix}-pub-ip"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = merge(local.common_tags, { role = var.networking-tag })
}

resource "azurerm_network_security_group" "nsg" {
  name                = "Allow-SSH"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = merge(local.common_tags, { role = var.networking-tag })
}

resource "azurerm_network_interface_security_group_association" "nic_nsg_assoc" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_interface" "nic" {
  name                = "${local.std_prefix}-nic"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pub_ip.id
  }

  tags = merge(local.common_tags, { role = var.networking-tag })
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "${local.std_prefix}-vm"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name

  size = "Standard_B1s"

  admin_username = var.user_vm

  admin_ssh_key {
    username   = var.user_vm
    public_key = file("./.ssh/id_rsa.pub")
  }

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = merge(local.common_tags, { role = var.compute-tag })
}