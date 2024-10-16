locals {
  transit_gateway_id  = var.existing_transit_gateway_name != null ? data.ibm_tg_gateway.existing_tg_gw_instance[0].id : ibm_tg_gateway.tg_gw_instance[0].id
  transit_gateway_crn = var.existing_transit_gateway_name != null ? data.ibm_tg_gateway.existing_tg_gw_instance[0].crn : ibm_tg_gateway.tg_gw_instance[0].crn
}

data "ibm_tg_gateway" "existing_tg_gw_instance" {
  count = var.existing_transit_gateway_name != null ? 1 : 0
  name  = var.existing_transit_gateway_name
}

resource "ibm_tg_gateway" "tg_gw_instance" {
  count          = var.existing_transit_gateway_name != null ? 0 : 1
  name           = var.transit_gateway_name
  location       = var.region
  global         = var.global_routing != null ? var.global_routing : false
  resource_group = var.resource_group_id != null ? var.resource_group_id : null
  tags           = var.resource_tags != null ? var.resource_tags : null
  timeouts {
    delete = var.delete_timeout
  }
}

resource "ibm_tg_connection" "vpc_connections" {
  count = length(var.vpc_connections)

  gateway               = local.transit_gateway_id
  network_type          = "vpc"
  name                  = "vpc_conn_inst${count.index}"
  network_id            = var.vpc_connections[count.index]
  default_prefix_filter = var.default_prefix_filter
}

resource "ibm_tg_connection" "classic_connections" {
  count = var.classic_connections_count

  gateway               = local.transit_gateway_id
  network_type          = "classic"
  name                  = "classic_conn_inst${count.index}"
  default_prefix_filter = var.default_prefix_filter
}


resource "ibm_tg_connection_prefix_filter" "add_prefix_filter" {
  count = length(var.add_prefix_filters) > 0 ? length(var.add_prefix_filters) : 0

  gateway       = ibm_tg_gateway.tg_gw_instance[0].id
  connection_id = ibm_tg_connection.vpc_connections[count.index].connection_id
  action        = var.add_prefix_filters[count.index].action
  prefix        = var.add_prefix_filters[count.index].prefix
  le            = var.add_prefix_filters[count.index].le
  ge            = var.add_prefix_filters[count.index].ge
}
