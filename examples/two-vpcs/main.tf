##############################################################################
# Resource Group
##############################################################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.4.8"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

##############################################################################
# 2 VPCs
##############################################################################

module "vpc_1" {
  source            = "terraform-ibm-modules/landing-zone-vpc/ibm"
  version           = "8.15.0"
  resource_group_id = module.resource_group.resource_group_id
  region            = var.region
  prefix            = var.prefix
  tags              = var.resource_tags
  name              = var.vpc1_name
  use_public_gateways = {
    zone-1 = false
    zone-2 = false
    zone-3 = false
  }
}

module "vpc_2" {
  source            = "terraform-ibm-modules/landing-zone-vpc/ibm"
  version           = "8.15.0"
  resource_group_id = module.resource_group.resource_group_id
  region            = var.region
  prefix            = var.prefix
  tags              = var.resource_tags
  name              = var.vpc2_name
  use_public_gateways = {
    zone-1 = false
    zone-2 = false
    zone-3 = false
  }
}

##############################################################################
# Transit Gateway connects the 2 VPCs
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
      vpc_crn = module.vpc_1.vpc_crn
    },
    {
      vpc_crn = module.vpc_2.vpc_crn
    }
  ]
}
