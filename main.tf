provider "vsphere" {
  # Configure the vCenter provider for on-premises vCenter
  user                 = var.vcenter_username
  password             = var.vcenter_password
  vsphere_server       = var.vcenter_server
  allow_unverified_ssl = true # Only use in testing environments
}

module "network" {
  source = "./modules/network" # Path to the network module
  
  # Pass required variables to the network module
  vpc_name            = var.vpc_name
  subnet_name         = var.subnet_name
  firewall_rules      = var.firewall_rules
  gcve_credentials    = var.gcve_credentials
}

module "hcx" {
  source = "./modules/hcx" # Path to the HCX module
  
  # Pass required variables to the HCX module
  hcx_manager_password = var.hcx_manager_password
  gcve_credentials     = var.gcve_credentials
  network_config       = module.network.network_config
}