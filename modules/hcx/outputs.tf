output "vm_id" {
  description = "ID of the migrated virtual machine on the target GCVE"
  value = vsphere_virtual_machine.this.id
}

# ... add other necessary output variables based on your requirements