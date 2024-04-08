output "disk_id" {
  value = [for volume in libvirt_volume.vm : volume.id]
}


output "cloudinit_id"{
    value = [for idx, cloudinit in libvirt_cloudinit_disk.cloudinit : cloudinit.id]
}