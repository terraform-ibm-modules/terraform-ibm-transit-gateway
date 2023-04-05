#  Example Transit Gateway that connects two VPCs in two different accounts

This example creates 2 VPCs in two different accounts (or as alternative allows to use an existing VPC for the second account), and illustrates how to provision a transit gateway in the first of them and to configure connectivity between the 2 VPCs, performing the approval action.

The Transit Gateway instance is created explicitly and then its name is passed to the main module as existing Transit Gateway for testing purposes.

Two providers are defined for the two IBM Cloud accounts involved into the example.

The approval action performed through the submodule `terraform-ibm-transit-gateway-action` can be applied in the same template and in the same session of the gateway creation: the dependency on the transit gateway ID makes it to wait for the transit gateway (along with its connections) creation before going on with the approval action.
