#####################################################
# Module Example
# Copyright 2020 IBM
#####################################################
data "ibm_resource_group" "resource_group" {
  name = var.resource_group_name
}

module "tg-gateway-connection" {
  source = "terraform-ibm-modules/transit-gateway/ibm//modules/tg-gateway-connection"

  transit_gateway_name       = var.transit_gateway_name
  location                   = var.location
  global_routing             = var.global_routing
  tags                       = var.tags
  resource_group_id          = data.ibm_resource_group.resource_group.id
  vpc_connections            = var.vpc_connections
  classic_connnections_count = var.classic_connnections_count
}