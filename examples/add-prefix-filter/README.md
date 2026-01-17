# Example transit gateway that connects two VPCs with prefix filtering

<!-- BEGIN SCHEMATICS DEPLOY HOOK -->
<a href="https://cloud.ibm.com/schematics/workspaces/create?workspace_name=transit-gateway-add-prefix-filter-example&repository=https://github.com/terraform-ibm-modules/terraform-ibm-transit-gateway/tree/main/examples/add-prefix-filter"><img src="https://img.shields.io/badge/Deploy%20with IBM%20Cloud%20Schematics-0f62fe?logo=ibm&logoColor=white&labelColor=0f62fe" alt="Deploy with IBM Cloud Schematics" style="height: 16px; vertical-align: text-bottom;"></a>
<!-- END SCHEMATICS DEPLOY HOOK -->


This example provisions two VPCs and a transit gateway that configures connectivity between them.

Add prefix filtering that determine the routes that transit gateway should accept or deny.

**Explanation:**
- Prefix filters can be used to permit or deny specific specific IP address ranges (called prefixes) on specific network connections.
- This helps to allow only traffic from trusted networks and block unwanted traffic from certain ranges.
- In this example, once deployed-
  - For both VPC connections vpc_conn_inst1 and vpc_conn_inst2, prefix filter will be created.
  - For VPC connection vpc_conn_inst1, default_prefix_filter is set to `permit` and prefix filters are `allow` 10.10.10.0/24 but `deny` 10.20.10.0/24. This means after processing the entries in the prefix filter list (allow 10.10.10.0/24 and deny 10.20.10.0/24) it accepts rest of the IP addresses.
  - For VPC connection vpc_conn_inst2, default_prefix_filter is set to `deny` and prefix filters is `allow` 10.20.10.0/24. This means after processing the entries in the prefix filter list (allow 10.20.10.0/24) it denies rest of the IP addresses.

<!-- BEGIN SCHEMATICS DEPLOY TIP HOOK -->
:information_source: Ctrl/Cmd+Click or right-click on the Schematics deploy button to open in a new tab
<!-- END SCHEMATICS DEPLOY TIP HOOK -->
