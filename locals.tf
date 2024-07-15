locals {
  vpc_prefix = "vpc-${var.environment_code}"

  vpc_spokes = { for key, value in local.vpcs :
    key => {
      uri = "https://www.googleapis.com/compute/v1/projects/${module.vpc[key].project_id}/global/networks/${module.vpc[key].network_name}"
    }
  if value.vpc_spoke == true }

  vpn_vpcs = [for key, value in local.vpcs : key if value.ha_vpn == true]
  vpn_tunnel_spokes = {
    "${module.vpn_onprem.gateway.0.name}" = {
      name       = module.vpn_onprem.name
      location   = provider::google::region_from_id(module.vpn_onprem.self_link)
      self_links = [for key, value in module.vpn_onprem.tunnel_self_links : value]
    }
    "${module.vpn_landing.gateway.0.name}" = {
      name       = module.vpn_landing.name
      location   = provider::google::region_from_id(module.vpn_landing.self_link)
      self_links = [for key, value in module.vpn_landing.tunnel_self_links : value]
    }
  }

  nva_vpcs = merge([
    for vpc, config in local.vpcs : {
      for subnet in config.subnets :
      "${vpc}-${subnet.subnet_region}" => {
        zone       = "${subnet.subnet_region}-a"
        router     = module.routers["${vpc}-${subnet.subnet_region}"].router.name
        subnet_id  = "projects/${var.project_id}/regions/${subnet.subnet_region}/subnetworks/${subnet.subnet_name}"
        router_asn = config.router_asn
        peer_asn   = config.peer_asn
      }
    } if config.nva == true
  ]...)
  nva_spokes = { for key, value in local.nva_vpcs :
    key => {
      name     = module.nva[key].name
      location = module.nva[key].region
      instances = [{
        virtual_machine = module.nva[key].self_link
        ip_address      = module.nva[key].ip_address
      }]
      router           = module.routers[key].router.name
      router_interface = module.nva[key].interface
      asn              = value.peer_asn
    }
  }

  vpcs = {
    "${local.vpc_prefix}-onprem" = {
      vpc_spoke  = false
      ha_vpn     = true
      nva        = false
      router_asn = 65000
      peer_asn   = 65001
      subnets = [
        {
          subnet_name           = "${local.vpc_prefix}-onprem-${var.default_region}"
          subnet_ip             = "10.10.0.0/24"
          subnet_region         = var.default_region
          subnet_private_access = "true"
        },
        {
          subnet_name           = "${local.vpc_prefix}-onprem-${var.default_region2}"
          subnet_ip             = "10.100.0.0/24"
          subnet_region         = var.default_region2
          subnet_private_access = "true"
        },
      ]
    },
    "${local.vpc_prefix}-landing" = {
      vpc_spoke  = false
      ha_vpn     = true
      nva        = false
      router_asn = 65010
      peer_asn   = 65011
      subnets = [
        {
          subnet_name           = "${local.vpc_prefix}-landing-${var.default_region}"
          subnet_ip             = "10.10.1.0/24"
          subnet_region         = var.default_region
          subnet_private_access = "true"
        },
        {
          subnet_name           = "${local.vpc_prefix}-landing-${var.default_region2}"
          subnet_ip             = "10.100.1.0/24"
          subnet_region         = var.default_region2
          subnet_private_access = "true"
        },
      ]
    },
    "${local.vpc_prefix}-hub-dmz" = {
      vpc_spoke  = true
      ha_vpn     = false
      nva        = false
      router_asn = 65020
      peer_asn   = 65021
      subnets = [
        {
          subnet_name           = "${local.vpc_prefix}-hub-dmz-${var.default_region}"
          subnet_ip             = "10.10.2.0/24"
          subnet_region         = var.default_region
          subnet_private_access = "true"
        },
        {
          subnet_name           = "${local.vpc_prefix}-hub-dmz-${var.default_region2}"
          subnet_ip             = "10.100.2.0/24"
          subnet_region         = var.default_region2
          subnet_private_access = "true"
        },
      ]
    },
    "${local.vpc_prefix}-hub-appdata" = {
      vpc_spoke  = true
      ha_vpn     = false
      nva        = false
      router_asn = 65030
      peer_asn   = 65031
      subnets = [
        {
          subnet_name           = "${local.vpc_prefix}-hub-appdata-${var.default_region}"
          subnet_ip             = "10.10.3.0/24"
          subnet_region         = var.default_region
          subnet_private_access = "true"
        },
        {
          subnet_name           = "${local.vpc_prefix}-hub-appdata-${var.default_region2}"
          subnet_ip             = "10.100.3.0/24"
          subnet_region         = var.default_region2
          subnet_private_access = "true"
        },
      ]
    },
    "${local.vpc_prefix}-hub-inet" = {
      vpc_spoke  = true
      ha_vpn     = false
      nva        = false
      router_asn = 65040
      peer_asn   = 65041
      subnets = [
        {
          subnet_name           = "${local.vpc_prefix}-hub-inet-${var.default_region}"
          subnet_ip             = "10.10.4.0/24"
          subnet_region         = var.default_region
          subnet_private_access = "true"
        },
        {
          subnet_name           = "${local.vpc_prefix}-hub-inet-${var.default_region2}"
          subnet_ip             = "10.100.4.0/24"
          subnet_region         = var.default_region2
          subnet_private_access = "true"
        },
      ]
    },
    "${local.vpc_prefix}-nva" = {
      vpc_spoke  = false
      ha_vpn     = false
      nva        = true
      router_asn = 65050
      peer_asn   = 65051
      subnets = [
        {
          subnet_name           = "${local.vpc_prefix}-nva-${var.default_region}"
          subnet_ip             = "10.10.5.0/24"
          subnet_region         = var.default_region
          subnet_private_access = "true"
        },
        {
          subnet_name           = "${local.vpc_prefix}-nva-${var.default_region2}"
          subnet_ip             = "10.100.5.0/24"
          subnet_region         = var.default_region2
          subnet_private_access = "true"
        },
      ]
    }
  }

  routers = merge([
    for vpc in module.vpc : {
      for subnet in vpc.subnets :
      "${vpc.network_name}-${subnet.region}" => {
        asn       = local.vpcs[vpc.network_name].router_asn
        name      = vpc.network_name
        network   = vpc.network_name
        region    = subnet.region
        subnet_id = subnet.id
      }
    }
  ]...)
}
