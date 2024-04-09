terraform {
    backend "local" {
    path = "terraform.tfstate"
  }
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.7.6"
    }
  }
}

provider "libvirt" {
    uri = "qemu:///system"
}

module "disk_module" {
    for_each = var.vm_main_configs
    source = "./disk-module"
    vm_disk_configs = {
      "${each.key}" = {
          name     = each.value.name
          source   = each.value.source
          user     = each.value.user
          format   = each.value.format
          ip       = each.value.ip
      }
    }
}

module "network_module" {
    source = "./network-module"
    depends_on = [module.disk_module]
}

module "vms_module" {
    for_each = var.vm_main_configs
    source = "./vms-module"
    depends_on = [module.network_module]
    vm_vms_configs = {
      "${each.key}" = {
          count   = each.value.count
          index   = each.value.index
          name    = each.value.name
          cpu     = each.value.cpu
          ram     = each.value.ram
          disk_id = { for key, module in module.disk_module : key => module.disk_id }["${each.key}"][each.value.index]
          cloudinit_id = { for key, module in module.disk_module : key => module.cloudinit_id }["${each.key}"][each.value.index]
          network_name = module.network_module.vm_network_name
      }
    }
}

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

resource "local_file" "ansible_hosts_file" {
  filename = "${path.module}/ansible_hosts.ini"
  content = <<-EOT
[masters]
${join("\n", [for host in local.master_hosts : "${host.name} ansible_host=${host.ip}"])}

[workers]
${join("\n", [for host in local.worker_hosts : "${host.name} ansible_host=${host.ip}"])}
EOT
}