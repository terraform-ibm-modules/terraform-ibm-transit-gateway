# Transit Gateway Module

This module is used to provision a transit gateway and configure multiple connections to it.

## Example Usage

```

data "ibm_resource_group" "resource_group" {
  name = var.resource_group_name
}

module "tg-gateway-connection" {
  source = "terraform-ibm-modules/transit-gateway/ibm//modules/tg-gateway-connection"

  transit_gateway_name = var.transit_gateway_name
  location             = var.location
  global_routing       = var.global_routing
  tags                 = var.tags
  resource_group_id    = data.ibm_resource_group.resource_group.id
  vpc_connections      = var.vpc_connections
  classic_connections_count   = var.classic_connections_count
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Inputs

| Name                              | Description                                                     | Type         | Default | Required |
|-----------------------------------|-----------------------------------------------------------------|--------------|---------|----------|
| transit_gateway_name              | Name of the transit gateway.                                    | string       | n/a     | yes      |
| location                          | Location of the transit gateway.                                | string       | n/a     | yes      |
| resource_group_name               | Name of the resource group.                                     | string       | n/a     | yes      |
| global_routing                    | On true, connect to the networks outside their associated region| bool         | false   | no       |
| vpc_connections                   | List of vpc crn to connect                                      | list(string) | n/a     | yes      |
| classic_connections_count         | Number of classic connections.                                   | number       | n/a     | yes      |
| tags                              | List of tags                                                    | list(string) | n/a     | no       |


<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## How to input variable values through a file

To review the plan for the configuration defined (no resources actually provisioned)

`terraform plan -var-file=./input.tfvars`

To execute and start building the configuration defined in the plan (provisions resources)

`terraform apply -var-file=./input.tfvars`

To destroy the VPC and all related resources

`terraform destroy -var-file=./input.tfvars`

All optional parameters by default will be set to null in respective example's variable.tf file. If user wants to configure any optional paramter he has overwrite the default value.

## Note

For all optional fields, default values (Eg: `null`) are given in variable.tf file. User can configure the same by overwriting with appropriate values.

## Outputs

| Name             | Description                    |
|------------------|--------------------------------|
| tg_id            | ID of the transit gateway      |
| tg_crn           | CRN of the gateway             |
| vpc_conn_ids     | List of vpc connection IDs     |
| classic_conn_ids | List of classic connection IDs |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->