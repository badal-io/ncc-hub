locals {
  default_rules = [
    {
      priority       = 400
      direction      = "INGRESS"
      action         = "allow"
      rule_name      = "allow-healthchecks"
      disabled       = false
      description    = "Allow healthchecks"
      enable_logging = false
      # target_secure_tags = ["l7-web-proxy"]
      match = {
        src_ip_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
        layer4_configs = [
          {
            ip_protocol = "tcp"
            ports       = ["3128"]
          }
        ]
      }
    },
    {
      priority       = 410
      direction      = "EGRESS"
      action         = "allow"
      rule_name      = "allow-egress"
      disabled       = false
      description    = "Allow egress"
      enable_logging = false
      match = {
        dest_ip_ranges = ["0.0.0.0/0"]
        layer4_configs = [
          {
            ip_protocol = "tcp"
            ports       = ["0-65535"]
          },
          {
            ip_protocol = "udp"
            ports       = ["0-65535"]
          },
        ]
      }
    },
    {
      priority       = 510
      direction      = "EGRESS"
      action         = "goto_next"
      rule_name      = "rfc1918-egress"
      disabled       = false
      description    = "RFC1918 egress"
      enable_logging = false
      match = {
        dest_ip_ranges = [
          "192.168.0.0/16",
          "10.0.0.0/8",
          "172.16.0.0/12",
        ]
        layer4_configs = [
          {
            ip_protocol = "all"
            ports       = []
          }
        ]
      }
    },
    {
      priority       = 4000
      direction      = "INGRESS"
      action         = "allow"
      rule_name      = "allow-bgp"
      disabled       = false
      description    = "Always allow bgp"
      enable_logging = false
      match = {
        src_ip_ranges = ["10.0.0.0/8", ]
        layer4_configs = [
          {
            ip_protocol = "tcp"
            ports       = ["179"]
          },
        ]
      }
    },
    {
      priority       = 5000
      direction      = "INGRESS"
      action         = "allow"
      rule_name      = "allow-ssh"
      disabled       = false
      description    = "Always allow SSH and RDP from IAP"
      enable_logging = false
      match = {
        src_ip_ranges = ["35.235.240.0/20"]
        layer4_configs = [
          {
            ip_protocol = "tcp"
            ports       = ["22", "3389"]
          },
        ]
      }
    },
  ]
  ingress_rules = var.enable_firewall_plus ? [
    {
      priority               = 500
      direction              = "INGRESS"
      action                 = "apply_security_profile_group"
      security_profile_group = module.firewall_endpoints.0.security_profile_group_id
      rule_name              = "rfc1918-ingress"
      disabled               = false
      description            = "RFC1918 ingress"
      enable_logging         = true
      match = {
        src_ip_ranges = [
          "192.168.0.0/16",
          "10.0.0.0/8",
          "172.16.0.0/12",
        ]
        layer4_configs = [
          {
            ip_protocol = "all"
            ports       = []
          }
        ]
      }
    },
    ] : [
    {
      priority               = 500
      direction              = "INGRESS"
      action                 = "allow"
      security_profile_group = null
      rule_name              = "rfc1918-ingress"
      disabled               = false
      description            = "RFC1918 ingress"
      enable_logging         = true
      match = {
        src_ip_ranges = [
          "192.168.0.0/16",
          "10.0.0.0/8",
          "172.16.0.0/12",
        ]
        layer4_configs = [
          {
            ip_protocol = "all"
            ports       = []
          }
        ]
      }
    },
  ]
  firewall_rules = concat(local.default_rules, local.ingress_rules)
}

module "network_firewall_policy" {
  source = "./modules/network-firewall-policy"
  # source  = "terraform-google-modules/network/google//modules/network-firewall-policy"
  # version = "~> 9.1"

  project_id  = var.project_id
  policy_name = "fp-${var.environment_code}-common-policies"
  description = "Firewall policies to test firewall endpoints"
  target_vpcs = []
  rules       = local.firewall_rules
}

resource "google_compute_network_firewall_policy_association" "default" {
  for_each          = { for vpc in module.vpc : vpc.network_name => vpc.network_id }
  project           = var.project_id
  name              = "${module.network_firewall_policy.fw_policy[0].name}-${element(split("/", each.value), length(split("/", each.value)) - 1)}"
  attachment_target = each.value
  firewall_policy   = module.network_firewall_policy.fw_policy[0].name
}
