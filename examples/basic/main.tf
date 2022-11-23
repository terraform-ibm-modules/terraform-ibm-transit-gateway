##############################################################################
# Resource Group
# (if var.resource_group is null, create a new RG using var.prefix)
##############################################################################

resource "ibm_resource_group" "resource_group" {
  count    = var.resource_group != null ? 0 : 1
  name     = "${var.prefix}-rg"
  quota_id = null
}

data "ibm_resource_group" "existing_resource_group" {
  count = var.resource_group != null ? 1 : 0
  name  = var.resource_group
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
  resource_group_id         = var.resource_group != null ? data.ibm_resource_group.existing_resource_group[0].id : ibm_resource_group.resource_group[0].id
  vpc_connections           = var.vpc_connections
  classic_connections_count = var.classic_connections_count
}
