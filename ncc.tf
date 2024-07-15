module "ncc" {
  source = "./modules/ncc"

  project_id        = var.project_id
  hub_name          = "demo-${var.environment_code}"
  vpc_spokes        = local.vpc_spokes
  vpn_tunnel_spokes = local.vpn_tunnel_spokes
  nva_spokes        = local.nva_spokes
}
