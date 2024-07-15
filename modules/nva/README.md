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
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_address.address_peer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address) | resource |
| [google_compute_address.interface](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address) | resource |
| [google_compute_address.interface_redundant](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address) | resource |
| [google_compute_instance.nva](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance) | resource |
| [google_compute_router_interface.interface](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_interface) | resource |
| [google_compute_router_interface.interface_redundant](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_interface) | resource |
| [random_integer.octet](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |
| [google_compute_subnetwork.router](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_subnetwork) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The name to use when creating the router appliance resources | `string` | n/a | yes |
| <a name="input_peer_asn"></a> [peer\_asn](#input\_peer\_asn) | The router appliance ASN | `number` | `65513` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project ID of the Firewall Endpoint. If `billing_project_id=null`  this is also used as the billing project for the Firewall Endpoint. | `string` | n/a | yes |
| <a name="input_router"></a> [router](#input\_router) | The id of the router to use for the BGP session | `string` | n/a | yes |
| <a name="input_router_asn"></a> [router\_asn](#input\_router\_asn) | The cloud router ASN | `number` | `64514` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The subnet to reserve the IPs used for the BGP session | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | The zone to create the router appliance | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_interface"></a> [interface](#output\_interface) | The name of the cloud router interface created for the nva vm |
| <a name="output_ip_address"></a> [ip\_address](#output\_ip\_address) | The description of the nvs vm |
| <a name="output_name"></a> [name](#output\_name) | The name of the nvs vm |
| <a name="output_redundant_interface"></a> [redundant\_interface](#output\_redundant\_interface) | The name of the redundant cloud router interface created for the nva vm |
| <a name="output_region"></a> [region](#output\_region) | The region of the nva vm |
| <a name="output_self_link"></a> [self\_link](#output\_self\_link) | The uri of the nva vm |
| <a name="output_zone"></a> [zone](#output\_zone) | The zone of the nva vm |
<!-- END_TF_DOCS -->