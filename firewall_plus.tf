module "firewall_endpoints" {
  count  = var.enable_firewall_plus ? 1 : 0
  source = "./modules/firewall-endpoint"

  providers = {
    google-beta = google-beta.billing-project
  }

  org_id     = var.org_id
  project_id = var.project_id
  zones      = ["us-central1-a"]
  vpcs = [for vpc in module.vpc : {
    name = vpc.network_name
    id   = vpc.network_id
  } if !strcontains(vpc.network_name, "onprem")]
  security_profile = {
    name = "alert"
    severity_overrides = [
      {
        action   = "ALERT"
        severity = "CRITICAL"
      },
      {
        action   = "ALERT"
        severity = "HIGH"
      },
      {
        action   = "ALERT"
        severity = "INFORMATIONAL"
      },
      {
        action   = "ALERT"
        severity = "LOW"
      },
      {
        action   = "ALERT"
        severity = "MEDIUM"
      },
    ]
  }
}
