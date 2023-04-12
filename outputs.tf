# Output variables for the HCX migration

output "hcx_manager_ip" {
  description = "IP address of HCX Manager on GCVE"
  value       = module.hcx.hcx_manager_ip
}

output "hcx_connector_ip" {
  description = "IP address of HCX Connector on GCVE"
  value       = module.hcx.hcx_connector_ip
}