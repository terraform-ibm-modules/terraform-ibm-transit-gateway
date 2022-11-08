#####################################################
# Module Example
# Copyright 2020 IBM
#####################################################
data "ibm_resource_group" "resource_group" {
  name = var.resource_group_name
}

module "tg_gateway_connection" {
  # Uncommnet the following line to point the source to registry level
  # source = "terraform-ibm-modules/transit-gateway/ibm//modules/tg-gateway-connection"

  source                    = "../../modules/tg-gateway-connection"
  transit_gateway_name      = var.transit_gateway_name
  location                  = var.location
  global_routing            = var.global_routing
  tags                      = var.tags
  resource_group_id         = data.ibm_resource_group.resource_group.id
  vpc_connections           = var.vpc_connections
  classic_connections_count = var.classic_connections_count
}
