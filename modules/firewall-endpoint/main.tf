locals {
  org                = "organizations/${var.org_id}"
  project            = "projects/${var.project_id}"
  billing_project_id = coalesce(var.billing_project_id, var.project_id)

  firewall_endpoint_mappings = flatten([for fep in google_network_security_firewall_endpoint.default :
    [for vpc in var.vpcs : {
      fep_id   = fep.id,
      vpc_name = vpc.name,
      vpc_id   = vpc.id,
      location = fep.location
    }]
  ])
  firewall_endpoint_associations = {
    for k, v in local.firewall_endpoint_mappings :
    "${v.vpc_name}/${v.location}" => v
  }
}



resource "google_network_security_firewall_endpoint" "default" {
  provider           = google-beta
  for_each           = toset(var.zones)
  name               = "${var.prefix}-${each.key}"
  parent             = local.org
  location           = each.key
  billing_project_id = local.billing_project_id
}

resource "google_network_security_firewall_endpoint_association" "default" {
  # This resources is not availble in the beta provider
  for_each          = local.firewall_endpoint_associations
  name              = "${var.prefix}-${each.value.vpc_name}-${each.value.location}"
  parent            = local.project
  location          = each.value.location
  network           = each.value.vpc_id
  firewall_endpoint = each.value.fep_id
}

resource "google_network_security_security_profile" "default" {
  provider = google-beta
  name     = "${var.prefix}-${var.security_profile.name}"
  parent   = local.org
  type     = "THREAT_PREVENTION"

  threat_prevention_profile {
    dynamic "severity_overrides" {
      for_each = var.security_profile.severity_overrides
      content {
        action   = severity_overrides.value.action
        severity = severity_overrides.value.severity
      }
    }
    dynamic "threat_overrides" {
      for_each = { for t in var.security_profile.threat_overrides : t.threat_id => t }
      content {
        action    = threat_overrides.value.action
        threat_id = threat_overrides.value.threat_id
        type      = threat_overrides.value.type
      }
    }
  }
}

resource "google_network_security_security_profile_group" "default" {
  provider                  = google-beta
  name                      = "${var.prefix}-${var.security_profile.name}-group"
  parent                    = local.org
  threat_prevention_profile = google_network_security_security_profile.default.id
}
