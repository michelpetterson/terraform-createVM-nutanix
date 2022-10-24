output "vm_ip" {
  value = zipmap(values(nutanix_virtual_machine.vm)[*].name,
  values(nutanix_virtual_machine.vm)[*].nic_list_status[0].ip_endpoint_list[0].ip)
}
