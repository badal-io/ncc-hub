variable "org_id" {
  description = "Organization ID for the security profile/group."
  type        = string
}

variable "project_id" {
  description = "Project ID of the Firewall Endpoint. If `billing_project_id=null`  this is also used as the billing project for the Firewall Endpoint."
  type        = string
}

variable "billing_project_id" {
  description = "Project ID used for billing the Firewall Endpoint. If this is `null` then `var.project_id` is used for billing."
  type        = string
  default     = null
}

variable "prefix" {
  description = "The prefix for the Firewall Endpoint, Security Profile/Group."
  type        = string
  default     = "fep"
}

variable "zones" {
  description = "List of zones to deploy the Firewall Endpoint."
  type        = list(string)
}

variable "vpcs" {
  description = "List of VPCs to associate the Firewall Endpoint."
  type = list(object({
    name = string
    id   = string
  }))
}

variable "security_profile" {
  description = "(optional) describe your variable"
  type = object({
    name   = string
    labels = optional(map(string), {})
    severity_overrides = optional(list(object({
      action   = string
      severity = string
    })), [])
    threat_overrides = optional(list(object({
      action    = string
      threat_id = string
      type      = optional(string, "")
    })), [])
  })
  default = {
    name = "sec-profile"
  }
}
