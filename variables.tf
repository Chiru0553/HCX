# Input variables for the HCX migration

variable "vcenter_username" {
  description = "Username for the on-premises vCenter"
}

variable "vcenter_password" {
  description = "Password for the on-premises vCenter"
}

variable "vcenter_server" {
  description = "Hostname or IP address of the on-premises vCenter"
}

variable "vpc_name" {
  description = "Name of the VPC to be created on GCVE"
}

variable "subnet_name" {
  description = "Name of the subnet to be created on GCVE"
}

variable "firewall_rules" {
  description = "List of firewall rules to be created on GCVE"
  type = list(object({
    name        = string
    source_cidr = string
    port        = string
    protocol    = string
  }))
}

variable "gcve_credentials" {
  description = "GCVE credentials for HCX migration"
  type = object({
    project_id     = string
    location       = string
    org_id         = string
    billing_account= string
    credentials    = string
  })
}

variable "hcx_manager_password" {
  description = "Password for HCX Manager"
}