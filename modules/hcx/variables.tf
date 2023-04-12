// onprem hcx server details
variable "hcx_server" {
  type = string
  description = "URL for the on-premises hcx instance"
  default = "https://local-hcx-connector.abc.com"
}

variable "admin_un" {
  type = string
  description = "Admin username for the on-premises hcx instance"
  default = "administrator@abc.com"
}

variable "admin_pw" {
  type = string
  description = "Admin password for the on-premises hcx instance"
  default = "updateme"
}

// target hcx server details
variable "gcve_hcx_server" {
  type = string
  description = "URL for the remote/ target hcx instance"
  default = "https://gcve-hcx-connector.abc.com"
}

variable "gcve_admin_un" {
  type = string
  description = "Admin username for the remote/ target hcx instance"
  default = "administrator@abc.com"
}

variable "gcve_admin_pw" {
  type = string
  description = "Admin password for the remote/ target hcx instance"
  default = "updateme"
}