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
# 3 VPCs
##############################################################################

module "vpc_1" {
  source            = "terraform-ibm-modules/landing-zone-vpc/ibm"
  version           = "8.15.3"
  resource_group_id = module.resource_group.resource_group_id
  region            = var.region
  prefix            = var.prefix
  tags              = var.resource_tags
  name              = "vpc1"
  use_public_gateways = {
    zone-1 = false
    zone-2 = false
    zone-3 = false
  }
}

module "vpc_2" {
  source            = "terraform-ibm-modules/landing-zone-vpc/ibm"
  version           = "8.15.3"
  resource_group_id = module.resource_group.resource_group_id
  region            = var.region
  prefix            = var.prefix
  tags              = var.resource_tags
  name              = "vpc2"
  use_public_gateways = {
    zone-1 = false
    zone-2 = false
    zone-3 = false
  }
}

module "vpc_3" {
  source            = "terraform-ibm-modules/landing-zone-vpc/ibm"
  version           = "8.15.3"
  resource_group_id = module.resource_group.resource_group_id
  region            = var.region
  prefix            = var.prefix
  tags              = var.resource_tags
  name              = "vpc3"
  use_public_gateways = {
    zone-1 = false
    zone-2 = false
    zone-3 = false
  }
}

module "vpc_4" {
  source            = "terraform-ibm-modules/landing-zone-vpc/ibm"
  version           = "8.15.3"
  resource_group_id = module.resource_group.resource_group_id
  region            = var.region
  prefix            = var.prefix
  tags              = var.resource_tags
  name              = "vpc4"
  use_public_gateways = {
    zone-1 = false
    zone-2 = false
    zone-3 = false
  }
}

##############################################################################
# Transit Gateway connecting the 2 VPCs - created in Account A and passed as existing gateway
##############################################################################

resource "ibm_tg_gateway" "tg_gw_instance" {
  name           = var.transit_gateway_name
  location       = var.region
  global         = false
  resource_group = module.resource_group.resource_group_id
  tags           = var.resource_tags
}

##############################################################################
# Transit Gateway connections connecting the 4 VPCs
##############################################################################

module "tg_gateway_connection_1" {
  depends_on = [
    ibm_tg_gateway.tg_gw_instance
  ]
  source                        = "../.."
  existing_transit_gateway_name = ibm_tg_gateway.tg_gw_instance.name
  region                        = var.region
  global_routing                = false
  resource_tags                 = var.resource_tags
  resource_group_id             = module.resource_group.resource_group_id
  classic_connections_count     = 0
  vpc_connections = [
    {
      connection_name = "vpc1-connection"
      vpc_crn         = module.vpc_1.vpc_crn
    },
    {
      connection_name = "vpc2-connection"
      vpc_crn         = module.vpc_2.vpc_crn
    }
  ]
}

module "tg_gateway_connection_2" {
  depends_on = [
    ibm_tg_gateway.tg_gw_instance
  ]
  source                        = "../.."
  existing_transit_gateway_name = ibm_tg_gateway.tg_gw_instance.name
  region                        = var.region
  global_routing                = false
  resource_tags                 = var.resource_tags
  resource_group_id             = module.resource_group.resource_group_id
  classic_connections_count     = 0
  vpc_connections = [
    {
      connection_name = "vpc3-connection"
      vpc_crn         = module.vpc_3.vpc_crn
    },
    {
      connection_name = "vpc4-connection"
      vpc_crn         = module.vpc_4.vpc_crn
    }
  ]
}
