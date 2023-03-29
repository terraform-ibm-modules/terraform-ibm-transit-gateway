#### Account A resources

##############################################################################
# Resource Group
##############################################################################

resource "ibm_resource_group" "resource_group_a" {
  count    = var.resource_group_a != null ? 0 : 1
  name     = "${var.prefix_a}-rg"
  quota_id = null
  provider = ibm.accountA
}

data "ibm_resource_group" "existing_resource_group_a" {
  count    = var.resource_group_a != null ? 1 : 0
  name     = var.resource_group_a
  provider = ibm.accountA
}

module "vpc_a" {
  source            = "git::https://github.com/terraform-ibm-modules/terraform-ibm-landing-zone-vpc.git?ref=v5.0.1"
  resource_group_id = var.resource_group_a != null ? data.ibm_resource_group.existing_resource_group_a[0].id : ibm_resource_group.resource_group_a[0].id
  region            = var.region_a
  prefix            = var.prefix_a
  tags              = var.resource_tags_a
  name              = var.vpc_name_a
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

resource "ibm_resource_group" "resource_group_b" {
  count    = var.resource_group_b != null ? 0 : 1
  name     = "${var.prefix_b}-rg"
  quota_id = null
  provider = ibm.accountB
}

data "ibm_resource_group" "existing_resource_group_b" {
  count    = var.resource_group_b != null ? 1 : 0
  name     = var.resource_group_b
  provider = ibm.accountB
}


locals {
  vpc_b_crn = var.existing_vpc_crn_b != null ? var.existing_vpc_crn_b : module.vpc_b[0].vpc_crn
}

module "vpc_b" {
  # if existing_vpc_crn_b is set using the existing VPC instead of creating a new one
  count             = var.existing_vpc_crn_b != null ? 0 : 1
  source            = "git::https://github.com/terraform-ibm-modules/terraform-ibm-landing-zone-vpc.git?ref=v5.0.1"
  resource_group_id = var.resource_group_b != null ? data.ibm_resource_group.existing_resource_group_b[0].id : ibm_resource_group.resource_group_b[0].id
  region            = var.region_b
  prefix            = var.prefix_b
  tags              = var.resource_tags_b
  name              = var.vpc_name_b
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
# Transit Gateway connects the 2 VPCs - created in Account A
##############################################################################

module "tg_gateway_connection" {
  source                    = "../.."
  transit_gateway_name      = var.transit_gateway_name
  region                    = var.region_a
  global_routing            = false
  resource_tags             = var.resource_tags_a
  resource_group_id         = var.resource_group_a != null ? data.ibm_resource_group.existing_resource_group_a[0].id : ibm_resource_group.resource_group_a[0].id
  vpc_connections           = [module.vpc_a.vpc_crn, local.vpc_b_crn]
  classic_connections_count = 0
  providers = {
    ibm = ibm.accountA
  }
}

###### approval action

module "tg_gateway_connection_crossaccounts_approve" {
  count = var.run_approval == true ? 1 : 0
  depends_on = [
    module.tg_gateway_connection
  ]
  source             = "../../terraform-ibm-transit-gateway-action"
  vpc_connection_ids = [module.tg_gateway_connection.vpc_conn_ids[local.vpc_b_crn]]
  transit_gw_id      = module.tg_gateway_connection.tg_id
  action             = "approve"
  providers = {
    ibm = ibm.accountB
  }
}
