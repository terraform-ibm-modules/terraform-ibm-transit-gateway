#  Example transit gateway that connects two VPCs in two accounts

This example creates two VPCs in two accounts. You can also use an existing VPC for the second account. The code provisions a transit gateway in the first account and configures connectivity between the two VPCs with an approval action on the connection.

The example implements the following infrastructure:

- Creates an IBM Cloud Transit Gateway instance. The name of the instance is passed to the main module as the existing transit gateway for testing purposes.
- Defines two providers for the two IBM Cloud accounts.
- Runs an approval action in the same session as when the gateway is created. A dependency exists on the transit gateway ID. The action waits until the transit gateway is created and the connections are set up before the approval is applied. The approval action is defined in the `terraform-ibm-transit-gateway-action` submodule.
