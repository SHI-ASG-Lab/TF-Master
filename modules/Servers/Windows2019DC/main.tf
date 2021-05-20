
# Create a public IP for the system to use
resource "azurerm_public_ip" "azPubIp" {
  name = "${var.VmName}-PubIp1"
  resource_group_name = var.resource_group_name
  location = var.RGlocation
  allocation_method = "Static"
}
# Create NIC for the VM
resource "azurerm_network_interface" "main" {
  name                = "${var.VmName}-nic1"
  location            = var.RGlocation
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = var.int_subnet_id
    private_ip_address_allocation = "static"
    private_ip_address = "10.0.2.${var.ipnum}"
    public_ip_address_id = azurerm_public_ip.azPubIp.id
    primary = true
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = var.VmName
  location              = var.RGlocation
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.main.id]
  primary_network_interface_id = azurerm_network_interface.main.id
  vm_size               = "Standard_E2s_v3"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.VmName}-osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = var.VmName
    admin_username = "shi"
    admin_password = "5ecur!ty_10I"
  }
  os_profile_windows_config {
  }

  tags     = var.tags
}

# Configure Auto-Shutdown for the AD Server for each night at 10pm CST.
resource "azurerm_dev_test_global_vm_shutdown_schedule" "AutoShutdown" {
  virtual_machine_id = azurerm_virtual_machine.main.id
  location           = var.RGlocation
  enabled            = true
  daily_recurrence_time = "2100"
  timezone              = "Central Standard Time"

  notification_settings {
    enabled         = false
  }
}