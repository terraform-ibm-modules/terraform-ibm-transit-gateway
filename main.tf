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
  count                 = length(var.vpc_connections)
  gateway               = local.transit_gateway_id
  network_type          = "vpc"
  name                  = var.vpc_connections[count.index].connection_name != null ? var.vpc_connections[count.index].connection_name : "vpc_conn_inst${count.index + 1}"
  network_id            = var.vpc_connections[count.index].vpc_crn
  default_prefix_filter = var.vpc_connections[count.index].default_prefix_filter
}
locals {
  filter_list = flatten([
    for conn in ibm_tg_connection.vpc_connections :
    [
      for filter in var.add_prefix_filters :
      merge(filter, { connection_id = conn.connection_id
      gateway = conn.gateway }) if filter.connection == conn.network_id
    ]
  ])
}
resource "ibm_tg_connection" "classic_connections" {
  count        = var.classic_connections_count
  gateway      = local.transit_gateway_id
  network_type = "classic"
  name         = "classic_conn_inst${count.index}"
}

resource "ibm_tg_connection_prefix_filter" "add_prefix_filter" {
  count         = length(var.add_prefix_filters) > 0 ? length(var.add_prefix_filters) : 0
  gateway       = local.filter_list[count.index].gateway
  connection_id = local.filter_list[count.index].connection_id
  action        = local.filter_list[count.index].action
  prefix        = local.filter_list[count.index].prefix
  le            = local.filter_list[count.index].le
  ge            = local.filter_list[count.index].ge
}
