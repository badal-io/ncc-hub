# NCC Hub / Firewall Endpoints
This repository creates demo infrastructure for an NCC Hub with optional Firewall Endpoints in 2 regions. The NCC hub showcases dynamic route exchange, which allows for VPC Spokes to be in the same NCC Hub as Hybrid Spokes (VPN Tunnel, Interconnect, or Router Instance). By default, the firewall endpoints are not deployed. They can be enabled by simply setting `enable_firewall_plus = true` in the [terraform.tfvars](./terraform.tfvars).

## Prerequisites
* Install terraform >= 1.8
* Update the values in the [terraform.tfvars](./terraform.tfvars)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.29 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | ~> 5.29 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 5.29 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_firewall_endpoints"></a> [firewall\_endpoints](#module\_firewall\_endpoints) | ./modules/firewall-endpoint | n/a |
| <a name="module_ncc"></a> [ncc](#module\_ncc) | ./modules/ncc | n/a |
| <a name="module_network_firewall_policy"></a> [network\_firewall\_policy](#module\_network\_firewall\_policy) | ./modules/network-firewall-policy | n/a |
| <a name="module_nva"></a> [nva](#module\_nva) | ./modules/nva | n/a |
| <a name="module_routers"></a> [routers](#module\_routers) | terraform-google-modules/cloud-router/google | ~> 6.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-google-modules/network/google | ~> 9.1 |
| <a name="module_vpn_landing"></a> [vpn\_landing](#module\_vpn\_landing) | terraform-google-modules/vpn/google//modules/vpn_ha | ~> 4.0 |
| <a name="module_vpn_onprem"></a> [vpn\_onprem](#module\_vpn\_onprem) | terraform-google-modules/vpn/google//modules/vpn_ha | ~> 4.0 |

## Resources

| Name | Type |
|------|------|
| [google_compute_instance.workload](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance) | resource |
| [google_compute_network_firewall_policy_association.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_firewall_policy_association) | resource |
| [google_project_service.project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_region"></a> [default\_region](#input\_default\_region) | Default region | `string` | n/a | yes |
| <a name="input_default_region2"></a> [default\_region2](#input\_default\_region2) | Default region 2 | `string` | n/a | yes |
| <a name="input_enable_firewall_plus"></a> [enable\_firewall\_plus](#input\_enable\_firewall\_plus) | Enable firewall plus | `bool` | `false` | no |
| <a name="input_environment_code"></a> [environment\_code](#input\_environment\_code) | Environment code | `string` | n/a | yes |
| <a name="input_firewall_enable_logging"></a> [firewall\_enable\_logging](#input\_firewall\_enable\_logging) | Enable firelwall logging | `bool` | `false` | no |
| <a name="input_org_id"></a> [org\_id](#input\_org\_id) | Org ID (Requried for firewall endpoints) | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP Project ID | `string` | n/a | yes |
| <a name="input_services"></a> [services](#input\_services) | Services to enable in project | `list(string)` | <pre>[<br>  "networksecurity.googleapis.com",<br>  "networkconnectivity.googleapis.com",<br>  "serviceusage.googleapis.com"<br>]</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->