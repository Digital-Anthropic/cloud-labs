output "vm_network_name"{
    value = module.network_module.vm_network_name
}

output "disk_id" {
  value = { for key, module in module.disk_module : key => module.disk_id }
}

output "cloudinit_id" {
  value = { for key, module in module.disk_module : key => module.cloudinit_id }
}
