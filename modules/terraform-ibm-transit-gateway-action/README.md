# IBM Cloud Transit Gateway action module

With the IBM Cloud® Transit Gateway action module, you can approve or reject connection requests for a cross-account VPCs connection that uses a transit gateway. This scenario expects one account to own the transit gateway and one of the VPCs and a different account to own the second VPC. That second account receives an approval request that must be approved before the connection can be established.

For more information, see [adding a cross-account connection](https://cloud.ibm.com/docs/transit-gateway?topic=transit-gateway-adding-cross-account-connections&interface=ui) in the IBM Cloud Docs.

## Usage

```hcl

# provider for account B
provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key_ext # pragma: allowlist secret external account apikey
  region           = var.region_account_b
  alias            = "accountB"
}

module "tg_gateway_connection_crossaccounts_approve" {

  source  = "terraform-ibm-modules/transit-gateway/ibm//modules/terraform-ibm-transit-gateway-action"
  version = "latest" # Replace "latest" with a release version to lock into a specific release
  vpc_connection_ids = ["1f6df0af-c2b6-4f1a-97dd-29ed50a8e1f3"] // ID of the transit gateway connection resource
  transit_gw_id      = module.tg_gateway_connection.tg_id // ID of the transit gateway resource
  action             = "approve"
  providers = {
    ibm = ibm.accountB
  }
}
```

<!-- BEGIN EXAMPLES HOOK -->
## Examples

- [ Example transit gateway that connects two VPCs in two accounts](../examples/crossaccounts)
<!-- END EXAMPLES HOOK -->

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0, <1.7.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.52.0, < 2.0.0 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [ibm_tg_connection_action.classic_tg_cross_connection_approval](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/tg_connection_action) | resource |
| [ibm_tg_connection_action.vpc_tg_cross_connection_approval](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/tg_connection_action) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_action"></a> [action](#input\_action) | Action to peform on the list of cnnection ids. Allowed values are 'approve' or 'reject' | `string` | n/a | yes |
| <a name="input_classic_connection_ids"></a> [classic\_connection\_ids](#input\_classic\_connection\_ids) | The list of classic connection IDs to perform the action for the account owner of ibmcloud\_api\_key | `list(string)` | `[]` | no |
| <a name="input_transit_gw_id"></a> [transit\_gw\_id](#input\_transit\_gw\_id) | ID to the transit gateway where the cross-account connection is created | `string` | n/a | yes |
| <a name="input_vpc_connection_ids"></a> [vpc\_connection\_ids](#input\_vpc\_connection\_ids) | The list of vpc connection IDs to perform the action for the account owner of ibmcloud\_api\_key | `list(string)` | `[]` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_classic_tg_crossaacount_approvals"></a> [classic\_tg\_crossaacount\_approvals](#output\_classic\_tg\_crossaacount\_approvals) | Result for classic crossaccount actions |
| <a name="output_vpc_tg_crossaacount_approvals"></a> [vpc\_tg\_crossaacount\_approvals](#output\_vpc\_tg\_crossaacount\_approvals) | Result for vpc crossaccount actions |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contributing

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.
