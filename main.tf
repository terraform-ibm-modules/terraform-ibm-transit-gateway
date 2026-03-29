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
  for_each = {
    for connection in var.vpc_connections :
    connection.connection_name => connection
  }
  gateway               = local.transit_gateway_id
  network_type          = "vpc"
  name                  = each.value.connection_name
  network_id            = each.value.vpc_crn
  default_prefix_filter = each.value.default_prefix_filter
}

resource "ibm_tg_connection" "classic_connections" {
  count        = var.classic_connections_count
  gateway      = local.transit_gateway_id
  network_type = "classic"
  name         = "classic_conn_inst${count.index}"
}

resource "ibm_tg_connection" "directlink_connections" {
  for_each = {
    for connection in var.directlink_connections :
    connection.connection_name => connection
  }
  gateway               = local.transit_gateway_id
  network_type          = "directlink"
  name                  = each.value.connection_name
  network_id            = each.value.directlink_crn
  default_prefix_filter = each.value.default_prefix_filter
}

locals {
  filter_list = flatten([
    for connection in concat(
      values(ibm_tg_connection.vpc_connections),
      values(ibm_tg_connection.directlink_connections)
    ) :
    [
      for filter in var.add_prefix_filters :
      merge(filter, {
        connection_id = connection.connection_id
        gateway       = connection.gateway
      })
      if filter.connection == connection.network_id
    ]
  ])
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
