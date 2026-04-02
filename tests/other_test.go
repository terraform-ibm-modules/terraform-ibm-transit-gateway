package test

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestRunBasicExample(t *testing.T) {
	// t.Parallel() // Remove parallel testing due to rate limiting set by transit gateway team

	options := setupOptionsBasicExample(t, "tg")

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func TestRunMultipleConnectionsExample(t *testing.T) {
	// t.Parallel()  // Remove parallel testing due to rate limiting set by transit gateway team

	options := setupOptionsMultipleConnectionsExample(t, "multiconns-tg")

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func TestRun2VpcsExample(t *testing.T) {
	// t.Parallel()  // Remove parallel testing due to rate limiting set by transit gateway team

	options := setupOptions2VpcsExample(t, "twovpcs-tg")

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

// func setupOptionsCrossaccountsExample(t *testing.T, prefix string) *testhelper.TestOptions {
// 	const TwoVpcsExampleTerraformDir = "examples/crossaccounts"

// 	// loading and setting apikeys to perform the test
// 	// from TF_VAR_ibmcloud_api_key and TF_VAR_ibmcloud_api_key_ext env variables
// 	// to TF_VAR_ibmcloud_api_key_account_a and TF_VAR_ibmcloud_api_key_account_b env variables
// 	ibmCloudApiKeyAEnvVarName := "TF_VAR_ibmcloud_api_key"
// 	ibmCloudApiKeyA := ""
// 	valA, presentA := os.LookupEnv(ibmCloudApiKeyAEnvVarName)
// 	require.True(t, presentA)
// 	ibmCloudApiKeyA = valA
// 	ibmCloudApiKeyBEnvVarName := "TF_VAR_ibmcloud_api_key_ext"
// 	ibmCloudApiKeyB := ""
// 	valB, presentB := os.LookupEnv(ibmCloudApiKeyBEnvVarName)
// 	require.True(t, presentB)
// 	ibmCloudApiKeyB = valB
// 	os.Setenv("TF_VAR_ibmcloud_api_key_account_a", ibmCloudApiKeyA)
// 	os.Setenv("TF_VAR_ibmcloud_api_key_account_b", ibmCloudApiKeyB)

// 	options := testhelper.TestOptionsDefault(&testhelper.TestOptions{
// 		Testing:       t,
// 		Prefix:        prefix,
// 		TerraformDir:  TwoVpcsExampleTerraformDir,
// 		ResourceGroup: resourceGroup,
// 	})
// 	const ibmcloudApiKeyVar = "TF_VAR_ibmcloud_api_key"

// 	options.TerraformVars = map[string]interface{}{
// 		"transit_gateway_name": fmt.Sprintf("%s-%s", options.Prefix, "crosstg"),
// 		// using the same region of the target account
// 		"region_account_a": permanentResources["gestaging_vpc_region"],
// 		"region_account_b": permanentResources["gestaging_vpc_region"],
// 		"prefix_account_a": fmt.Sprintf("%s-%s", options.Prefix, "a"),
// 		// using existing vpc crn
// 		"existing_vpc_crn_account_b": permanentResources["gestaging_vpc_crn"],
// 		"resource_group_account_a":   options.ResourceGroup,
// 		"resource_group_account_b":   permanentResources["gestaging_rg"],
// 	}

// 	return options
// }

// The account that this test was using has been removed so disabling the test until we decide what account can be used

// func TestRunCrossaccountsExample(t *testing.T) {
// 	t.Parallel()

// 	options := setupOptionsCrossaccountsExample(t, "cross")

// 	output, err := options.RunTestConsistency()
// 	assert.Nil(t, err, "This should not have errored")
// 	assert.NotNil(t, output, "Expected some output")
// }
