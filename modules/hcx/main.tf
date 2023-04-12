resource "vsphere_virtual_machine" "this" {
  # Set the necessary configuration for the source vCenter virtual machine
  name      = var.vm_name
  vcenter   = var.vcenter_server
  username  = var.vcenter_username
  password  = var.vcenter_password
  datacenter = var.vcenter_datacenter
  folder    = var.vm_folder
  # ... add other necessary settings for the source VM

  # Set the HCX migration configuration
  custom_configuration_parameters = [
    {
      key   = "migration.hcx_on_prem_key"
      value = var.hcx_on_prem_key
    },
    {
      key   = "migration.hcx_on_prem_vc_address"
      value = var.hcx_on_prem_vc_address
    },
    {
      key   = "migration.hcx_on_prem_vc_username"
      value = var.hcx_on_prem_vc_username
    },
    {
      key   = "migration.hcx_on_prem_vc_password"
      value = var.hcx_on_prem_vc_password
    },
    # ... add other necessary HCX migration configuration settings
  ]

  # Set the target GCVE configuration
  annotation = jsonencode({
    hcx_key     = var.hcx_key
    hcx_cluster = var.hcx_cluster
  })

  # ... add other necessary settings for the target GCVE VM
}