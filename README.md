# IBM Cloud Transit Gateway - Terraform Module

This is a collection of modules that make it easier to provision transit gateway and configure multiple connections to it on IBM Cloud Platform:
* [tg-gateway-connection](modules/tg-gateway-connection)

## Compatibility

This module is meant for use with Terraform 0.13 (and higher).

## Usage

Full examples are in the [examples](./examples/) folder, demonstarte how to use a module through a template:

e.g:

```hcl
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

## Requirements

### Terraform plugins

- [Terraform](https://www.terraform.io/downloads.html) 0.13 (or later)
- [terraform-provider-ibm](https://github.com/IBM-Cloud/terraform-provider-ibm)

## Install

### Terraform

Be sure you have the correct Terraform version (0.13), you can choose the binary here:
- https://releases.hashicorp.com/terraform/

### Terraform plugins

Be sure you have the compiled plugins on $HOME/.terraform.d/plugins/

- [terraform-provider-ibm](https://github.com/IBM-Cloud/terraform-provider-ibm)

### Pre-commit hooks

Run the following command to execute the pre-commit hooks defined in .pre-commit-config.yaml file
```
pre-commit run -a
```
You can install pre-coomit tool using

```
pip install pre-commit
```
or
```
pip3 install pre-commit
```
## How to input variable values through a file

To review the plan for the configuration defined (no resources actually provisioned)
```
terraform plan -var-file=./input.tfvars
```
To execute and start building the configuration defined in the plan (provisions resources)
```
terraform apply -var-file=./input.tfvars
```

To destroy the VPC and all related resources
```
terraform destroy -var-file=./input.tfvars
```

To run the test case execute
```
go test -v -timeout 15m -run <TestCaseName>
```

## Note

All optional parameters, by default, will be set to `null` in respective example's variable.tf file. You can also override these optional parameters.

To create a transit gateway connection of network type `classic`, in the respective account virtual routing and forwarding (VRF) has to be enabled. please refer following doc to enable the VRF

https://cloud.ibm.com/docs/account?topic=account-vrf-service-endpoint#vrf

