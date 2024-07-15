module "nva" {
  source = "./modules/nva"

  for_each = local.nva_vpcs

  project_id = var.project_id
  name       = "quagga"
  zone       = each.value.zone
  router     = each.value.router
  subnet_id  = each.value.subnet_id
  router_asn = each.value.router_asn
  peer_asn   = each.value.peer_asn

  depends_on = [
    module.vpc,
    module.routers,
    module.network_firewall_policy,
  ]
}
