<!-- BEGIN_TF_DOCS -->
Copyright 2023 Google LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

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
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | >= 4.64, < 6 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_compute_network_firewall_policy_rule.rules](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_network_firewall_policy_rule) | resource |
| [google-beta_google_compute_region_network_firewall_policy_rule.rules](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_region_network_firewall_policy_rule) | resource |
| [google_compute_network_firewall_policy.fw_policy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_firewall_policy) | resource |
| [google_compute_network_firewall_policy_association.vpc_associations](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_firewall_policy_association) | resource |
| [google_compute_region_network_firewall_policy.fw_policy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_network_firewall_policy) | resource |
| [google_compute_region_network_firewall_policy_association.vpc_associations](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_network_firewall_policy_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | An optional description of this resource. Provide this property when you create the resource | `string` | `null` | no |
| <a name="input_policy_name"></a> [policy\_name](#input\_policy\_name) | User-provided name of the Network firewall policy | `string` | n/a | yes |
| <a name="input_policy_region"></a> [policy\_region](#input\_policy\_region) | Location of the firewall policy. Needed for regional firewall policies. Default is null (Global firewall policy) | `string` | `null` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project ID of the Network firewall policy | `string` | n/a | yes |
| <a name="input_rules"></a> [rules](#input\_rules) | List of Ingress/Egress rules | <pre>list(object({<br>    priority                = number<br>    direction               = string<br>    action                  = string<br>    security_profile_group  = optional(string)<br>    rule_name               = optional(string)<br>    disabled                = optional(bool)<br>    description             = optional(string)<br>    enable_logging          = optional(bool)<br>    target_secure_tags      = optional(list(string))<br>    target_service_accounts = optional(list(string))<br>    match = object({<br>      src_ip_ranges             = optional(list(string), [])<br>      src_fqdns                 = optional(list(string), [])<br>      src_region_codes          = optional(list(string), [])<br>      src_secure_tags           = optional(list(string), [])<br>      src_threat_intelligences  = optional(list(string), [])<br>      src_address_groups        = optional(list(string), [])<br>      dest_ip_ranges            = optional(list(string), [])<br>      dest_fqdns                = optional(list(string), [])<br>      dest_region_codes         = optional(list(string), [])<br>      dest_threat_intelligences = optional(list(string), [])<br>      dest_address_groups       = optional(list(string), [])<br>      layer4_configs = optional(list(object({<br>        ip_protocol = optional(string, "all")<br>        ports       = optional(list(string), [])<br>      })), [{}])<br>    })<br>  }))</pre> | `[]` | no |
| <a name="input_target_vpcs"></a> [target\_vpcs](#input\_target\_vpcs) | List of target VPC IDs that the firewall policy will be attached to | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_fw_policy"></a> [fw\_policy](#output\_fw\_policy) | Firewall policy created |
| <a name="output_rules"></a> [rules](#output\_rules) | Firewall policy rules created |
| <a name="output_vpc_associations"></a> [vpc\_associations](#output\_vpc\_associations) | VPC associations created |
<!-- END_TF_DOCS -->