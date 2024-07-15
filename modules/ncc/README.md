<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.64, < 6 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >= 4.64, < 6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.64, < 6 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_router_peer.peer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_peer) | resource |
| [google_network_connectivity_hub.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/network_connectivity_hub) | resource |
| [google_network_connectivity_spoke.nva_spokes](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/network_connectivity_spoke) | resource |
| [google_network_connectivity_spoke.vpc_spokes](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/network_connectivity_spoke) | resource |
| [google_network_connectivity_spoke.vpn_tunnel_spokes](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/network_connectivity_spoke) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_hub_description"></a> [hub\_description](#input\_hub\_description) | The description to use when creating the NCC Hub | `string` | `null` | no |
| <a name="input_hub_name"></a> [hub\_name](#input\_hub\_name) | The name to use when creating the NCC Hub | `string` | n/a | yes |
| <a name="input_nva_spokes"></a> [nva\_spokes](#input\_nva\_spokes) | List of VPN tunnel self\_links to be used for Hybrid spokes | <pre>map(object({<br>    name     = string<br>    location = string<br>    instances = list(object({<br>      virtual_machine = string<br>      ip_address      = string<br>    }))<br>    router                     = string<br>    router_interface           = string<br>    asn                        = number<br>    site_to_site_data_transfer = optional(bool, false)<br>  }))</pre> | `{}` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project ID for the resources | `string` | n/a | yes |
| <a name="input_vpc_spokes"></a> [vpc\_spokes](#input\_vpc\_spokes) | List of VPC self\_links to be used for VPC spokes | <pre>map(object({<br>    uri                   = string<br>    exclude_export_ranges = optional(list(string), [])<br>  }))</pre> | `{}` | no |
| <a name="input_vpn_tunnel_spokes"></a> [vpn\_tunnel\_spokes](#input\_vpn\_tunnel\_spokes) | List of VPN tunnel self\_links to be used for Hybrid spokes | <pre>map(object({<br>    name                       = string<br>    location                   = string<br>    self_links                 = list(string)<br>    site_to_site_data_transfer = optional(bool, false)<br>  }))</pre> | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->