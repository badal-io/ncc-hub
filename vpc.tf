module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 9.1"

  for_each     = local.vpcs
  project_id   = var.project_id
  network_name = each.key
  # shared_vpc_host = "true"
  # delete_default_internet_gateway_routes = "true"
  mtu     = 1460
  subnets = each.value.subnets
}

module "routers" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 6.0"

  for_each = local.routers
  name     = each.value.name
  project  = var.project_id
  network  = each.value.network
  region   = each.value.region

  bgp = {
    asn               = each.value.asn
    advertised_groups = ["ALL_SUBNETS"]
  }

  nats = [{
    name                               = "${each.value.name}-nat-gateway"
    source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
    log_config = {
      enable = "true"
      filter = "ERRORS_ONLY"
    }
  }]
}
