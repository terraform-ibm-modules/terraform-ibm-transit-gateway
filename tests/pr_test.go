package test

import (
	"fmt"
	"log"
	"maps"
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/cloudinfo"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/common"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
)

const resourceGroup = "geretain-test-transit-gw"

var sharedInfoSvc *cloudinfo.CloudInfoService

// Define a struct with fields that match the structure of the YAML data
const yamlLocation = "../common-dev-assets/common-go-assets/common-permanent-resources.yaml"

var permanentResources map[string]interface{}

// Runs before any parallel tests, used to set up a shared InfoService object to track region usage
func TestMain(m *testing.M) {
	sharedInfoSvc, _ = cloudinfo.NewCloudInfoServiceFromEnv("TF_VAR_ibmcloud_api_key", cloudinfo.CloudInfoServiceOptions{})

	// loading permanent resources from yaml
	var err error
	permanentResources, err = common.LoadMapFromYaml(yamlLocation)
	if err != nil {
		log.Fatal(err)
	}

	os.Exit(m.Run())
}

func setupOptionsBasicExample(t *testing.T, prefix string) *testhelper.TestOptions {
	const basicExampleTerraformDir = "examples/basic"
	var vpcConnections []string

	options := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
		Testing:          t,
		Prefix:           prefix,
		ResourceGroup:    resourceGroup,
		CloudInfoService: sharedInfoSvc, // use pointer to shared info svc to keep track of region selections
		DefaultRegion:    "us-south",
		TerraformDir:     basicExampleTerraformDir,
	})

	terraformVars := map[string]interface{}{
		"transit_gateway_name":      fmt.Sprintf("%s-%s", options.Prefix, "tg"),
		"vpc_connections":           vpcConnections,
		"classic_connections_count": 0,
	}

	maps.Copy(options.TerraformVars, terraformVars)

	return options
}

func setupOptions2VpcsExample(t *testing.T, prefix string) *testhelper.TestOptions {
	const TwoVpcsExampleTerraformDir = "examples/two-vpcs"

	options := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
		Testing:          t,
		Prefix:           prefix,
		ResourceGroup:    resourceGroup,
		CloudInfoService: sharedInfoSvc, // use pointer to shared info svc to keep track of region selections
		DefaultRegion:    "us-south",
		TerraformDir:     TwoVpcsExampleTerraformDir,
	})

	terraformVars := map[string]interface{}{
		"transit_gateway_name": fmt.Sprintf("%s-%s", options.Prefix, "tg"),
	}

	maps.Copy(options.TerraformVars, terraformVars)

	return options
}

func setupOptionsMultipleConnectionsExample(t *testing.T, prefix string) *testhelper.TestOptions {
	const TwoVpcsExampleTerraformDir = "examples/multiple-connections"

	options := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
		Testing:          t,
		Prefix:           prefix,
		ResourceGroup:    resourceGroup,
		CloudInfoService: sharedInfoSvc, // use pointer to shared info svc to keep track of region selections
		DefaultRegion:    "us-south",
		TerraformDir:     TwoVpcsExampleTerraformDir,
	})

	terraformVars := map[string]interface{}{
		"transit_gateway_name": fmt.Sprintf("%s-%s", options.Prefix, "tg"),
	}

	maps.Copy(options.TerraformVars, terraformVars)

	return options
}

func setupOptions2VpcsPrefixFilterExample(t *testing.T, prefix string) *testhelper.TestOptions {
	const PrefixExampleTerraformDir = "examples/add-prefix-filter"

	options := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
		Testing:          t,
		Prefix:           prefix,
		ResourceGroup:    resourceGroup,
		CloudInfoService: sharedInfoSvc, // use pointer to shared info svc to keep track of region selections
		DefaultRegion:    "us-south",
		TerraformDir:     PrefixExampleTerraformDir,
		IgnoreUpdates: testhelper.Exemptions{ // Ignore for consistency check
			List: []string{
				// to skip update error due to updated in-place for ibm_tg_connection_prefix_filter, tracking provider issue https://github.com/IBM-Cloud/terraform-provider-ibm/issues/5885
				"module.tg_gateway_connection.ibm_tg_connection_prefix_filter.add_prefix_filter[0]",
				"module.tg_gateway_connection.ibm_tg_connection_prefix_filter.add_prefix_filter[1]",
			},
		},
	})

	terraformVars := map[string]interface{}{
		"transit_gateway_name": fmt.Sprintf("%s-%s", options.Prefix, "tg"),
	}

	maps.Copy(options.TerraformVars, terraformVars)

	return options
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

func TestRunBasicExample(t *testing.T) {
	t.Parallel()

	options := setupOptionsBasicExample(t, "tg")

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func TestRun2VpcsExample(t *testing.T) {
	t.Parallel()

	options := setupOptions2VpcsExample(t, "twovpcs-tg")

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func TestRunMultipleConnectionsExample(t *testing.T) {
	t.Parallel()

	options := setupOptionsMultipleConnectionsExample(t, "multiconns-tg")

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func TestRun2VpcsPrefixFilterExample(t *testing.T) {
	t.Parallel()

	options := setupOptions2VpcsPrefixFilterExample(t, "prefix-tg")

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

// The account that this test was using has been removed so disabling the test until we decide what account can be used

// func TestRunCrossaccountsExample(t *testing.T) {
// 	t.Parallel()

// 	options := setupOptionsCrossaccountsExample(t, "cross")

// 	output, err := options.RunTestConsistency()
// 	assert.Nil(t, err, "This should not have errored")
// 	assert.NotNil(t, output, "Expected some output")
// }

func TestRunUpgradeExample(t *testing.T) {
	t.Parallel()

	options := setupOptionsBasicExample(t, "ibm-tgn")

	output, err := options.RunTestUpgrade()
	if !options.UpgradeTestSkipped {
		assert.Nil(t, err, "This should not have errored")
		assert.NotNil(t, output, "Expected some output")
	}
}
