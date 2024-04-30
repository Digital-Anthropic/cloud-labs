variable "vm_main_configs" {
  type = map(object({
   count   = number
    index   = number
    name    = string
    cpu     = number
    ram     = number
   source   = string
   user     = string
   format   = string
   ip       = string
   is_master = bool
  }))
}