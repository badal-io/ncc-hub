locals {
  bgp_peers = merge([
    for key, nva in var.nva_spokes : {
      for instance in nva.instances :
      "${nva.name}" => {
        name             = nva.name
        region           = nva.location
        router           = nva.router
        router_interface = nva.router_interface
        self_link        = instance.virtual_machine
        asn              = nva.asn
        ip_address       = instance.ip_address
      }
    }
  ]...)
}

resource "google_network_connectivity_hub" "default" {
  project     = var.project_id
  name        = "${var.hub_name}-ncc-hub"
  description = var.hub_description
}

resource "google_network_connectivity_spoke" "vpc_spokes" {
  for_each    = var.vpc_spokes
  project     = var.project_id
  name        = "${provider::google::name_from_id(each.value.uri)}-vpc-spoke"
  location    = "global"
  description = "A VPC Spoke for ${provider::google::name_from_id(each.value.uri)}"

  hub = google_network_connectivity_hub.default.id
  linked_vpc_network {
    uri                   = each.value.uri
    exclude_export_ranges = each.value.exclude_export_ranges
  }
}

resource "google_network_connectivity_spoke" "vpn_tunnel_spokes" {
  for_each    = var.vpn_tunnel_spokes
  project     = var.project_id
  name        = "${each.value.name}-vpn-spoke"
  location    = each.value.location
  description = "A Hybrid Spoke for the ${each.value.name} vpn tunnel"

  hub = google_network_connectivity_hub.default.id
  linked_vpn_tunnels {
    # NB: all Spokes with site_to_site_data_transfer enabled must belong to the same VPC network
    site_to_site_data_transfer = each.value.site_to_site_data_transfer
    uris                       = each.value.self_links
  }
}

resource "google_network_connectivity_spoke" "nva_spokes" {
  for_each    = var.nva_spokes
  project     = var.project_id
  name        = "${each.value.name}-nva-spoke"
  location    = each.value.location
  description = "A Hybrid spoke for the ${each.value.name} nva spoke"

  hub = google_network_connectivity_hub.default.id
  linked_router_appliance_instances {
    # NB: all Spokes with site_to_site_data_transfer enabled must belong to the same VPC network
    site_to_site_data_transfer = each.value.site_to_site_data_transfer

    dynamic "instances" {
      for_each = each.value.instances
      content {
        virtual_machine = instances.value.virtual_machine
        ip_address      = instances.value.ip_address
      }
    }
  }
}

resource "google_compute_router_peer" "peer" {
  for_each                  = local.bgp_peers
  project                   = var.project_id
  name                      = "${each.value.name}-peer"
  region                    = each.value.region
  router                    = each.value.router
  interface                 = each.value.router_interface
  router_appliance_instance = each.value.self_link
  peer_asn                  = each.value.asn
  peer_ip_address           = each.value.ip_address

  depends_on = [google_network_connectivity_spoke.nva_spokes]
}
