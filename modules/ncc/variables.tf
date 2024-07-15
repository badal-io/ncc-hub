variable "project_id" {
  description = "Project ID for the resources"
  type        = string
}

variable "hub_name" {
  description = "The name to use when creating the NCC Hub"
  type        = string
}

variable "hub_description" {
  description = "The description to use when creating the NCC Hub"
  type        = string
  default     = null
}

variable "vpc_spokes" {
  description = "List of VPC self_links to be used for VPC spokes"
  type = map(object({
    uri                   = string
    exclude_export_ranges = optional(list(string), [])
  }))
  default = {}
}

variable "vpn_tunnel_spokes" {
  description = "List of VPN tunnel self_links to be used for Hybrid spokes"
  type = map(object({
    name                       = string
    location                   = string
    self_links                 = list(string)
    site_to_site_data_transfer = optional(bool, false)
  }))
  default = {}
}

variable "nva_spokes" {
  description = "List of VPN tunnel self_links to be used for Hybrid spokes"
  type = map(object({
    name     = string
    location = string
    instances = list(object({
      virtual_machine = string
      ip_address      = string
    }))
    router                     = string
    router_interface           = string
    asn                        = number
    site_to_site_data_transfer = optional(bool, false)
  }))
  default = {}
}
