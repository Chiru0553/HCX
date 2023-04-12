variable "vm_name" {
  description = "Name of the source vCenter virtual machine"
}

variable "vcenter_server" {
  description = "URL of the vCenter server"
}

variable "vcenter_username" {
  description = "Username to authenticate with the vCenter server"
}

variable "vcenter_password" {
  description = "Password to authenticate with the vCenter server"
  sensitive = true
}

variable "vcenter_datacenter" {
  description = "Name of the datacenter where the source VM is located"
}

variable "vm_folder" {
  description = "Name of the folder in the vCenter inventory where the source VM is located"
}

variable "hcx_on_prem_key" {
  description = "HCX on-premises key for the migration"
}

variable "hcx_on_prem_vc_address" {
  description = "Address of the on-premises vCenter server for HCX"
}

variable "hcx_on_prem_vc_username" {
  description = "Username to authenticate with the on-premises vCenter server for HCX"
}

variable "hcx_on_prem_vc_password" {
  description = "Password to authenticate with the on-premises vCenter server for HCX"
  sensitive = true
}

variable "hcx_key" {
  description = "HCX key for the target GCVE"
}

variable "hcx_cluster" {
  description = "Name of the HCX cluster on the target GCVE"
}

# ... add other necessary input variables based on your requirements