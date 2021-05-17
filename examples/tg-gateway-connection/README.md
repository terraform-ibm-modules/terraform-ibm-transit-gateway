# Transit Gateway Module Example

This example illustrates how to provision a transit gateway and configure multiple connections to it.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Inputs

| Name                              | Description                                                     | Type         | Default | Required |
|-----------------------------------|-----------------------------------------------------------------|--------------|---------|----------|
| transit_gateway_name              | Name of the transit gateway.                                    | string       | n/a     | yes      |
| location                          | Location of the transit gateway.                                | string       | n/a     | yes      |
| resource_group_name               | Name of the resource group.                                     | string       | n/a     | yes      |
| global_routing                    | On true, connect to the networks outside their associated region| bool         | false   | no       |
| vpc_connections                   | List of vpc crn to connect                                      | list(string) | n/a     | yes      |
| classic_connections_count         | Number of classic connections.                                  | number       | n/a     | yes      |
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