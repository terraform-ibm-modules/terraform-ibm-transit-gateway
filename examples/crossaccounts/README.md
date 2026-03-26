# Example transit gateway that connects two VPCs in two accounts

<!-- BEGIN SCHEMATICS DEPLOY HOOK -->
<p>
  <a href="https://cloud.ibm.com/schematics/workspaces/create?workspace_name=transit-gateway-crossaccounts-example&repository=https://github.com/terraform-ibm-modules/terraform-ibm-transit-gateway/tree/main/examples/crossaccounts">
    <img src="https://img.shields.io/badge/Deploy%20with%20IBM%20Cloud%20Schematics-0f62fe?style=flat&logo=ibm&logoColor=white&labelColor=0f62fe" alt="Deploy with IBM Cloud Schematics">
  </a><br>
  ℹ️ Ctrl/Cmd+Click or right-click on the Schematics deploy button to open in a new tab.
</p>
<!-- END SCHEMATICS DEPLOY HOOK -->

This example creates two VPCs in two accounts. You can also use an existing VPC for the second account. The code provisions a transit gateway in the first account and configures connectivity between the two VPCs with an approval action on the connection.

The example implements the following infrastructure:

- Creates an IBM Cloud Transit Gateway instance. The name of the instance is passed to the main module as the existing transit gateway for testing purposes.
- Defines two providers for the two IBM Cloud accounts.
- Runs an approval action in the same session as when the gateway is created. A dependency exists on the transit gateway ID. The action waits until the transit gateway is created and the connections are set up before the approval is applied. The approval action is defined in the `terraform-ibm-transit-gateway-action` submodule in `modules` folder .
