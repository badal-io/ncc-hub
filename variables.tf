variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "environment_code" {
  type        = string
  description = "Environment code"
}

variable "default_region" {
  type        = string
  description = "Default region"
}

variable "default_region2" {
  type        = string
  description = "Default region 2"
}

variable "firewall_enable_logging" {
  type        = bool
  description = "Enable firelwall logging"
  default     = false
}

variable "enable_firewall_plus" {
  type        = bool
  description = "Enable firewall plus"
  default     = false
}

variable "org_id" {
  type        = string
  description = "Org ID (Requried for firewall endpoints)"
}

variable "services" {
  type        = list(string)
  description = "Services to enable in project"
  default = [
    "networksecurity.googleapis.com",
    "networkconnectivity.googleapis.com",
    "serviceusage.googleapis.com",
  ]
}
