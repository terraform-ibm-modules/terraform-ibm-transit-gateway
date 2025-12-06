##############################################################################
# Resource Group
##############################################################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.4.2"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}


##############################################################################
# Transit Gateway
##############################################################################

module "tg_gateway_connection" {
  source                    = "../.."
  transit_gateway_name      = var.transit_gateway_name
  region                    = var.region
  global_routing            = var.global_routing
  resource_tags             = var.resource_tags
  resource_group_id         = module.resource_group.resource_group_id
  vpc_connections           = var.vpc_connections
  classic_connections_count = var.classic_connections_count
}
