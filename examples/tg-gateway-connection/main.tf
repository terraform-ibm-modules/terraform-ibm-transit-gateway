data "ibm_resource_group" "resource_group" {
  name = var.resource_group_name
}

module "tg_gateway_connection" {
  source                    = "../.."
  transit_gateway_name      = var.transit_gateway_name
  location                  = var.location
  global_routing            = var.global_routing
  tags                      = var.tags
  resource_group_id         = data.ibm_resource_group.resource_group.id
  vpc_connections           = var.vpc_connections
  classic_connections_count = var.classic_connections_count
}
