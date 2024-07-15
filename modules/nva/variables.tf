variable "project_id" {
  description = "Project ID of the Firewall Endpoint. If `billing_project_id=null`  this is also used as the billing project for the Firewall Endpoint."
  type        = string
}

variable "name" {
  description = "The name to use when creating the router appliance resources"
  type        = string
}

variable "zone" {
  description = "The zone to create the router appliance"
  type        = string
}

variable "router" {
  description = "The id of the router to use for the BGP session"
  type        = string
}

variable "subnet_id" {
  description = "The subnet to reserve the IPs used for the BGP session"
  type        = string
}

variable "router_asn" {
  type        = number
  description = "The cloud router ASN"
  default     = 64514
}

variable "peer_asn" {
  type        = number
  description = "The router appliance ASN"
  default     = 65513
}
