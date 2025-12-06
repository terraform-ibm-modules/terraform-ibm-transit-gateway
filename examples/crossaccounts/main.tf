#### Account A resources

##############################################################################
# Resource Group
##############################################################################

module "resource_group_account_a" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.4.1"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group_account_a == null ? "${var.prefix_account_a}-resource-group" : null
  existing_resource_group_name = var.resource_group_account_a
}


module "vpc_a" {
  source            = "terraform-ibm-modules/landing-zone-vpc/ibm"
  version           = "8.10.0"
  resource_group_id = module.resource_group_account_a.resource_group_id
  region            = var.region_account_a
  prefix            = var.prefix_account_a
  tags              = var.resource_tags_account_a
  name              = var.vpc_name_account_a
  use_public_gateways = {
    zone-1 = false
    zone-2 = false
    zone-3 = false
  }
  providers = {
    ibm = ibm.accountA
  }
}

#### Account B resources

##############################################################################
# Resource Group
##############################################################################

module "resource_group_account_b" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.4.1"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group_account_b == null ? "${var.prefix_account_b}-resource-group" : null
  existing_resource_group_name = var.resource_group_account_b
}



locals {
  vpc_b_crn = var.existing_vpc_crn_account_b != null ? var.existing_vpc_crn_account_b : module.vpc_b[0].vpc_crn
}

module "vpc_b" {
  # if existing_vpc_crn_account_b is set using the existing VPC instead of creating a new one
  count             = var.existing_vpc_crn_account_b != null ? 0 : 1
  source            = "terraform-ibm-modules/landing-zone-vpc/ibm"
  version           = "8.10.0"
  resource_group_id = module.resource_group_account_b.resource_group_id
  region            = var.region_account_b
  prefix            = var.prefix_account_b
  tags              = var.resource_tags_account_b
  name              = var.vpc_name_account_b
  use_public_gateways = {
    zone-1 = false
    zone-2 = false
    zone-3 = false
  }
  providers = {
    ibm = ibm.accountB
  }
}

##############################################################################
# Transit Gateway connecting the 2 VPCs - created in Account A and passed as existing gateway
##############################################################################

resource "ibm_tg_gateway" "tg_gw_instance" {
  name           = var.transit_gateway_name
  location       = var.region_account_a
  global         = false
  resource_group = module.resource_group_account_a.resource_group_id
  tags           = var.resource_tags_account_a
  provider       = ibm.accountA
}

##############################################################################
# Cross-accounts transit gateway connection - created in Account A and using existing Transit Gateway instance
##############################################################################

module "tg_gateway_connection" {
  depends_on = [
    ibm_tg_gateway.tg_gw_instance
  ]
  source                        = "../.."
  existing_transit_gateway_name = ibm_tg_gateway.tg_gw_instance.name
  vpc_connections               = [module.vpc_a.vpc_crn, local.vpc_b_crn]
  classic_connections_count     = 0
  providers = {
    ibm = ibm.accountA
  }
}

##############################################################################
# Cross-accounts transit gateway connection - approval action performed on the Account B
##############################################################################

module "tg_gateway_connection_crossaccounts_approve" {
  source             = "../../modules/terraform-ibm-transit-gateway-action"
  vpc_connection_ids = [module.tg_gateway_connection.vpc_conn_ids[local.vpc_b_crn]]
  transit_gw_id      = module.tg_gateway_connection.tg_id
  action             = "approve"
  providers = {
    ibm = ibm.accountB
  }
}
