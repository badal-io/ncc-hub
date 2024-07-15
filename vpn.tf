module "vpn_onprem" {
  source  = "terraform-google-modules/vpn/google//modules/vpn_ha"
  version = "~> 4.0"

  project_id       = var.project_id
  region           = var.default_region
  network          = module.vpc[local.vpn_vpcs[1]].network_self_link
  name             = "${local.vpn_vpcs[1]}-to-${local.vpn_vpcs[0]}"
  peer_gcp_gateway = module.vpn_landing.self_link
  router_asn       = module.routers["${local.vpn_vpcs[1]}-${var.default_region}"].router.bgp.0.asn
  router_name      = module.routers["${local.vpn_vpcs[1]}-${var.default_region}"].router.name

  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = "169.254.1.1"
        asn     = module.routers["${local.vpn_vpcs[0]}-${var.default_region}"].router.bgp.0.asn
      }
      bgp_peer_options                = null
      bgp_session_range               = "169.254.1.2/30"
      ike_version                     = 2
      vpn_gateway_interface           = 0
      peer_external_gateway_interface = null
      shared_secret                   = ""
    }

    remote-1 = {
      bgp_peer = {
        address = "169.254.2.1"
        asn     = module.routers["${local.vpn_vpcs[0]}-${var.default_region}"].router.bgp.0.asn
      }
      bgp_peer_options                = null
      bgp_session_range               = "169.254.2.2/30"
      ike_version                     = 2
      vpn_gateway_interface           = 1
      peer_external_gateway_interface = null
      shared_secret                   = ""
    }

  }
}

module "vpn_landing" {
  source  = "terraform-google-modules/vpn/google//modules/vpn_ha"
  version = "~> 4.0"

  project_id       = var.project_id
  region           = var.default_region
  network          = module.vpc[local.vpn_vpcs[0]].network_self_link
  name             = "${local.vpn_vpcs[0]}-to-${local.vpn_vpcs[1]}"
  peer_gcp_gateway = module.vpn_onprem.self_link
  router_asn       = module.routers["${local.vpn_vpcs[0]}-${var.default_region}"].router.bgp.0.asn
  router_name      = module.routers["${local.vpn_vpcs[0]}-${var.default_region}"].router.name

  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = "169.254.1.2"
        asn     = module.routers["${local.vpn_vpcs[1]}-${var.default_region}"].router.bgp.0.asn
      }
      bgp_session_range     = "169.254.1.1/30"
      ike_version           = 2
      vpn_gateway_interface = 0
      shared_secret         = module.vpn_onprem.random_secret
    }

    remote-1 = {
      bgp_peer = {
        address = "169.254.2.2"
        asn     = module.routers["${local.vpn_vpcs[1]}-${var.default_region}"].router.bgp.0.asn
      }
      bgp_session_range     = "169.254.2.1/30"
      ike_version           = 2
      vpn_gateway_interface = 1
      shared_secret         = module.vpn_onprem.random_secret
    }

  }
}
