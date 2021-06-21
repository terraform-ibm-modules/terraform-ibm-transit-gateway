package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestAccIBMCloudTgConnection(t *testing.T) {
	t.Parallel()

	// Construct the terraform options with default retryable errors to handle the most common retryable errors in
	// terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../examples/tg-gateway-connection",

		Vars: map[string]interface{}{
			"transit_gateway_name":      "my-gw",
			"location":                  "us-south",
			"global_routing":            true,
			"vpc_connections":           []string{"crn:v1:bluemix:public:is:us-south:a/fcdb764102154c7ea8e1b79d3a64afe0::vpc:r006-2f795247-a00b-4f11-94da-b7098918c28c"},
			"tags":                      []string{"T1", "T2"},
			"classic_connections_count": 0,
			"resource_group_name":       "default",
		},
	})

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)
}
