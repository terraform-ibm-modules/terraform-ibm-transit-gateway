# IBM Cloud Transit Gateway - Terraform Module

<!-- UPDATE BADGE: Update the link for the following badge-->
[![Graduated (Supported)](https://img.shields.io/badge/Status-Graduated%20(Supported)-brightgreen)](https://terraform-ibm-modules.github.io/documentation/#/badge-status)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![latest release](https://img.shields.io/github/v/release/terraform-ibm-modules/terraform-ibm-transit-gateway?logo=GitHub&sort=semver)](https://github.com/terraform-ibm-modules/terraform-ibm-transit-gateway/releases/latest)
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com/)


With IBM Cloud® Transit Gateway, you can create single or multiple transit gateways to connect VPCs. You can also connect your IBM Cloud classic infrastructure to a transit gateway to provide seamless communication with classic infrastructure resources. Any new network that you connect to a transit gateway is then made available to every other network connected to it. For more information, see [About IBM Cloud Transit Gateway](https://cloud.ibm.com/docs/transit-gateway?topic=transit-gateway-about) in the IBM Cloud docs.

This module includes the `terraform-ibm-transit-gateway-action` [approval action submodule](terraform-ibm-transit-gateway-action/README.md) that supports approving or rejecting connection requests in cross-account VPC connections.

<!-- Below content is automatically populated via pre-commit hook -->
<!-- BEGIN OVERVIEW HOOK -->
## Overview
* [terraform-ibm-transit-gateway](#terraform-ibm-transit-gateway)
* [Submodules](./modules)
    * [terraform-ibm-transit-gateway-action](./modules/terraform-ibm-transit-gateway-action)
* [Examples](./examples)
    * [ Example transit gateway that connects two VPCs in two accounts](./examples/crossaccounts)
    * [ Example transit gateway that connects two VPCs](./examples/two-vpcs)
    * [Example basic transit gateway](./examples/basic)
* [Contributing](#contributing)
<!-- END OVERVIEW HOOK -->

<!-- Match this heading to the name of the root level module (the repo name) -->
## terraform-ibm-transit-gateway

### Usage

```hcl
data "ibm_resource_group" "resource_group" {
  name = "resource_group_name"
}

module "tg_gateway_connection" {
  source                    = "terraform-ibm-modules/transit-gateway/ibm"
  version                   = "X.X.X" # Replace "X.X.X" with a release version to lock into a specific release
  transit_gateway_name      = "transit gateway name"
  location                  = "eu-de"
  global_routing            = true
  tags                      = ["tag1", "tag2"]
  resource_group_id         = data.ibm_resource_group.resource_group.id
  vpc_connections           = ["crn:v1:bluemix:public:is:eu-de:a/7aa6f7b185f2e3170fac9919aa1769ee::vpc:r010-a9fdc623-d702-4381-a116-07546dba1b87","crn:v1:bluemix:public:is:eu-de:a/7aa6f7b185f2e3170fac9919aa1769ee::vpc:r010-4c39039d-e7ef-411d-a191-3cb549dc41a1"]
  classic_connections_count = false
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0, <1.6.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.52.0, < 2.0.0 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [ibm_tg_connection.classic_connections](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/tg_connection) | resource |
| [ibm_tg_connection.vpc_connections](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/tg_connection) | resource |
| [ibm_tg_gateway.tg_gw_instance](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/tg_gateway) | resource |
| [ibm_tg_gateway.existing_tg_gw_instance](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/tg_gateway) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_classic_connections_count"></a> [classic\_connections\_count](#input\_classic\_connections\_count) | Number of classic connections to add. | `number` | n/a | yes |
| <a name="input_delete_timeout"></a> [delete\_timeout](#input\_delete\_timeout) | Deleting timeout value of the ibm\_tg\_gateway | `string` | `"45m"` | no |
| <a name="input_existing_transit_gateway_name"></a> [existing\_transit\_gateway\_name](#input\_existing\_transit\_gateway\_name) | Name of an existing transit gateway to connect VPCs. If null a new Transit Gateway will be created (transit\_gateway\_name and region required) | `string` | `null` | no |
| <a name="input_global_routing"></a> [global\_routing](#input\_global\_routing) | Gateways with global routing (true) to connect to the networks outside their associated region | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | The IBM Cloud region where all resources are provisioned. It can be null if existing\_transit\_gateway\_name is not null | `string` | `null` | no |
| <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id) | Resource group ID where the transit gateway to be created. | `string` | `null` | no |
| <a name="input_resource_tags"></a> [resource\_tags](#input\_resource\_tags) | List of tags | `list(string)` | `null` | no |
| <a name="input_transit_gateway_name"></a> [transit\_gateway\_name](#input\_transit\_gateway\_name) | Name of the transit gateway to create. It can be null if existing\_transit\_gateway\_name is not null | `string` | `null` | no |
| <a name="input_vpc_connections"></a> [vpc\_connections](#input\_vpc\_connections) | The list of vpc instance resource\_crn to add network connections for. | `list(string)` | n/a | yes |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_classic_conn_ids"></a> [classic\_conn\_ids](#output\_classic\_conn\_ids) | List of classic connection IDs |
| <a name="output_tg_crn"></a> [tg\_crn](#output\_tg\_crn) | CRN of the gateway |
| <a name="output_tg_id"></a> [tg\_id](#output\_tg\_id) | The ID of the transit gateway |
| <a name="output_vpc_conn_ids"></a> [vpc\_conn\_ids](#output\_vpc\_conn\_ids) | List of VPC connection IDs |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contributing

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.
