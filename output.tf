
#output "ip_address" {
#  value = libvirt_domain.test[count.index].network_interface[0].addresses[0]
#  description = "ssh  -o StrictHostKeyChecking=no -o LogLevel=ERROR -o UserKnownHostsFile=/dev/null flamur@192.168.122.206"
#}

output "ips" {
  value = libvirt_domain.my_domain_masters.*.network_interface.0.addresses
}

### The Ansible inventory file
resource "local_file" "AnsibleInventory" {
  content = templatefile("inventory.tmpl",
    {
      private-ip-masters = libvirt_domain.my_domain_masters.*.network_interface.0.addresses
      private-ip-workers = libvirt_domain.my_domain_workers.*.network_interface.0.addresses
    }
  )
  filename = "hosts"
}
