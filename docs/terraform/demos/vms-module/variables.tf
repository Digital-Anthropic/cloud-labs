variable "vm_vms_configs" {
  type = map(object({
    count   = number
    index   = number
    name    = string
    cpu     = number
    ram     = number
    disk_id = any
    cloudinit_id = any
    network_name = string
  }))
}