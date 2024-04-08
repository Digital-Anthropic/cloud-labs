variable "vm_disk_configs" {
  type = map(object({
    name     = string
    source   = string
    user     = string
    format   = string
    ip       = string
  }))
  default = {
    masterNode = {
      name     = "masterNode"
      source   = "https://cloud-images.ubuntu.com/releases/bionic/release/ubuntu-18.04-server-cloudimg-amd64.img"
      user     = "masternodeuser"
      format   = "qcow2"
      ip       = "10.10.10.11"
    }
  }
}

