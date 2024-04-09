terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.7.6"
    }
}
}

data "template_file" "user_data" {
    for_each = var.vm_disk_configs
    template = file("${path.module}/cloud_init.cfg")
    vars = {
        VM_USER = each.value.user
        VM_NAME = each.value.name
    }
}

data "template_file" "network_config"{
    for_each = var.vm_disk_configs
    template = file("${path.module}/network_config.cfg")
    vars = {
        IP = each.value.ip
    }
}

resource "libvirt_pool" "vm" {
    for_each = var.vm_disk_configs
    name = "${each.value.name}_pool"
    type = "dir"
    path = "/tmp/terraform-provider-libvirt-pool-ubuntu-${each.value.name}"
}

resource "libvirt_volume" "vm" {
    for_each = var.vm_disk_configs
    name = "${each.value.name}_volume.${each.value.format}"
    pool = libvirt_pool.vm[each.key].name
    source = each.value.source
    format = each.value.format
}


resource "libvirt_cloudinit_disk" "cloudinit" {
    for_each = var.vm_disk_configs
    name = "${each.value.name}_cloudinit.iso"
    user_data = data.template_file.user_data[each.key].rendered
    network_config = data.template_file.network_config[each.key].rendered
    pool = libvirt_pool.vm[each.key].name
}