# Example transit gateway that connects two VPCs with prefix filtering

This example provisions two VPCs and a transit gateway that configures connectivity between them.

Add prefix filtering that determine the routes that transit gateway should accept or deny.

**Explanation:**
- Prefix filters can be used to permit or deny specific specific IP address ranges (called prefixes) on specific network connections.
- This helps to allow only traffic from trusted networks and block unwanted traffic from certain ranges.
- In this example, once deployed-
  - For both VPC connections vpc_conn_inst1 and vpc_conn_inst2, prefix filter will be created.
  - For VPC connection vpc_conn_inst1, default_prefix_filter is set to `permit` and prefix filters are `allow` 10.10.10.0/24 but `deny` 10.20.10.0/24. This means after processing the entries in the prefix filter list (allow 10.10.10.0/24 and deny 10.20.10.0/24) it accepts rest of the IP addresses.
  - For VPC connection vpc_conn_inst2, default_prefix_filter is set to `deny` and prefix filters is `allow` 10.20.10.0/24. This means after processing the entries in the prefix filter list (allow 10.20.10.0/24) it denies rest of the IP addresses.
