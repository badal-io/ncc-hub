<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.0 |
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
| [google-beta_google_network_security_firewall_endpoint.default](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_network_security_firewall_endpoint) | resource |
| [google-beta_google_network_security_security_profile.default](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_network_security_security_profile) | resource |
| [google-beta_google_network_security_security_profile_group.default](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_network_security_security_profile_group) | resource |
| [google_network_security_firewall_endpoint_association.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/network_security_firewall_endpoint_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_billing_project_id"></a> [billing\_project\_id](#input\_billing\_project\_id) | Project ID used for billing the Firewall Endpoint. If this is `null` then `var.project_id` is used for billing. | `string` | `null` | no |
| <a name="input_org_id"></a> [org\_id](#input\_org\_id) | Organization ID for the security profile/group. | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The prefix for the Firewall Endpoint, Security Profile/Group. | `string` | `"fep"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project ID of the Firewall Endpoint. If `billing_project_id=null`  this is also used as the billing project for the Firewall Endpoint. | `string` | n/a | yes |
| <a name="input_security_profile"></a> [security\_profile](#input\_security\_profile) | (optional) describe your variable | <pre>object({<br>    name   = string<br>    labels = optional(map(string), {})<br>    severity_overrides = optional(list(object({<br>      action   = string<br>      severity = string<br>    })), [])<br>    threat_overrides = optional(list(object({<br>      action    = string<br>      threat_id = string<br>      type      = optional(string, "")<br>    })), [])<br>  })</pre> | <pre>{<br>  "name": "sec-profile"<br>}</pre> | no |
| <a name="input_vpcs"></a> [vpcs](#input\_vpcs) | List of VPCs to associate the Firewall Endpoint. | <pre>list(object({<br>    name = string<br>    id   = string<br>  }))</pre> | n/a | yes |
| <a name="input_zones"></a> [zones](#input\_zones) | List of zones to deploy the Firewall Endpoint. | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_security_profile_group_id"></a> [security\_profile\_group\_id](#output\_security\_profile\_group\_id) | An identifier for the security profile group with the format `{{parent}}/locations/{{location}}/securityProfileGroups/{{name}}` |
<!-- END_TF_DOCS -->