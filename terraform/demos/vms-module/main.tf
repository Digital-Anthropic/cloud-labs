terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.7.6"
    }
}
}

resource "libvirt_domain" "vm" {
  for_each = var.vm_vms_configs

  name    = each.value.name
  memory  = each.value.ram
  vcpu    = each.value.cpu

  cloudinit = each.value.cloudinit_id

  network_interface {
    network_name = each.value.network_name
  }

  console {
    type         = "pty"
    target_port  = "0"
    target_type  = "serial"
  }

  console {
    type         = "pty"
    target_type  = "virtio"
    target_port  = "1"
  }

  disk {
    volume_id = each.value.disk_id
  }

  graphics {
    type          = "spice"
    listen_type   = "address"
    autoport      = "true"
  }
}