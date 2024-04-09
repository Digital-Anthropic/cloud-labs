locals {
  master_hosts = [for key, value in var.vm_main_configs : {
    name = value.name
    ip = value.ip
  } if value.is_master]
  
  worker_hosts = [for key, value in var.vm_main_configs : {
    name = value.name
    ip = value.ip
  } if !value.is_master]
}
