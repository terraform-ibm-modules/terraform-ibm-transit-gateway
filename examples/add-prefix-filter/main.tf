##############################################################################
# Resource Group
##############################################################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.1.6"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

##############################################################################
# 2 VPCs
##############################################################################

module "vpc_1" {
  source            = "terraform-ibm-modules/landing-zone-vpc/ibm"
  version           = "7.22.1"
  resource_group_id = module.resource_group.resource_group_id
  region            = var.region
  prefix            = var.prefix
  tags              = var.resource_tags
  name              = "${var.prefix}-vpc1"
  use_public_gateways = {
    zone-1 = false
    zone-2 = false
    zone-3 = false
  }
}

module "vpc_2" {
  source            = "terraform-ibm-modules/landing-zone-vpc/ibm"
  version           = "7.22.1"
  resource_group_id = module.resource_group.resource_group_id
  region            = var.region
  prefix            = var.prefix
  tags              = var.resource_tags
  name              = "${var.prefix}-vpc2"
  use_public_gateways = {
    zone-1 = false
    zone-2 = false
    zone-3 = false
  }
}

##############################################################################
# Transit Gateway connects the 2 VPCs with prefix filters
##############################################################################

module "tg_gateway_connection" {
  source                    = "../.."
  transit_gateway_name      = var.transit_gateway_name
  region                    = var.region
  global_routing            = false
  resource_tags             = var.resource_tags
  resource_group_id         = module.resource_group.resource_group_id
  classic_connections_count = 0
  vpc_connections = [
    {
      vpc_crn               = module.vpc_1.vpc_crn
      default_prefix_filter = "permit"
    },
    {
      vpc_crn               = module.vpc_2.vpc_crn
      default_prefix_filter = "deny"
    }
  ]
  add_prefix_filters = [
    {
      action     = "permit"
      prefix     = "10.10.10.0/24"
      le         = 24
      ge         = 24
      connection = module.vpc_1.vpc_crn
    },
    {
      action     = "deny"
      prefix     = "10.20.10.0/24"
      le         = 24
      ge         = 24
      connection = module.vpc_1.vpc_crn
    },
    {
      action     = "permit"
      prefix     = "10.20.10.0/24"
      le         = 24
      ge         = 24
      connection = module.vpc_2.vpc_crn
    }
  ]
}
