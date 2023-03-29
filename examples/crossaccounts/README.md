#  Example Transit Gateway that connects two VPCs in two different accounts

This example creates 2 VPCs in two different accounts (or as alternative allows to use an existing VPC for the second account), and illustrates how to provision a transit gateway in the first of them and to configure connectivity between the 2 VPCs, performing the approval action.

Two providers are defined for the two IBM Cloud accounts involved into the example.

Due to a bug with provider at plan step https://github.com/IBM-Cloud/terraform-provider-ibm/issues/4445 the approval action must be performed when the resources are already created. This is why the example allows to run the same template twice with the input var `run_approval` set initially to *false* to skip the ibm_tg_connection_action resource and then again setting to *true* to run the approval step.
