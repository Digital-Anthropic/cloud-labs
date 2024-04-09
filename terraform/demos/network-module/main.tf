terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.7.6"
    }
}
}
resource "libvirt_network" "vm_public_network" {
    name = "${var.VM_HOSTNAME}_network"
    mode = "${var.VM_NETMODE}"
    domain = "${var.VM_HOSTNAME}.local"

    addresses = ["10.10.10.0/24"]
    
    dns {
        enabled = var.VM_DNS
    }
}

