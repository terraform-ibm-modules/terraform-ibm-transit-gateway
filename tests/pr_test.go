package test

import (
	"fmt"
	"log"
	"maps"
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
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
	var err error
	sharedInfoSvc, err = cloudinfo.NewCloudInfoServiceFromEnv("TF_VAR_ibmcloud_api_key", cloudinfo.CloudInfoServiceOptions{})
	if err != nil {
		log.Fatal(err)
	}

	// loading permanent resources from yaml
	permanentResources, err = common.LoadMapFromYaml(yamlLocation)
	if err != nil {
		log.Fatal(err)
	}

	os.Exit(m.Run())
}

func setupOptionsBasicExample(t *testing.T, prefix string) *testhelper.TestOptions {
	const basicExampleTerraformDir = "examples/basic"
	vpcConnections := []map[string]interface{}{}
	directLinkConnections := []map[string]interface{}{
		{
			"directlink_crn":        permanentResources["directlink_crn"],
			"default_prefix_filter": "permit",
			"connection_name":       "test_conn",
		},
	}

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
		"directlink_connections":    directLinkConnections,
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

func TestRun2VpcsPrefixFilterExample(t *testing.T) {
	t.Parallel()

	options := setupOptions2VpcsPrefixFilterExample(t, "prefix-tg")

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func setupOptionsCrossaccountsExample(t *testing.T, prefix string) *testhelper.TestOptions {
	const crossaccountsTerraformDir = "examples/crossaccounts"

	// Load API keys from environment variables and map them to the variable names
	// expected by the Terraform example (ibmcloud_api_key_account_a / _account_b).
	ibmCloudApiKeyA, presentA := os.LookupEnv("TF_VAR_ibmcloud_api_key")
	require.True(t, presentA, "TF_VAR_ibmcloud_api_key must be set")
	ibmCloudApiKeyB, presentB := os.LookupEnv("TF_VAR_ibmcloud_api_key_ext")
	require.True(t, presentB, "TF_VAR_ibmcloud_api_key_ext must be set")

	options := testhelper.TestOptionsDefault(&testhelper.TestOptions{
		Testing:       t,
		Prefix:        prefix,
		TerraformDir:  crossaccountsTerraformDir,
		ResourceGroup: resourceGroup,
	})

	options.TerraformVars = map[string]interface{}{
		"ibmcloud_api_key_account_a": ibmCloudApiKeyA,
		"ibmcloud_api_key_account_b": ibmCloudApiKeyB,
		"transit_gateway_name":       fmt.Sprintf("%s-%s", options.Prefix, "crosstg"),
		"region_account_a":           permanentResources["tg_crossaccount_vpc_region"],
		"region_account_b":           permanentResources["tg_crossaccount_vpc_region"],
		"prefix_account_a":           fmt.Sprintf("%s-%s", options.Prefix, "a"),
		"existing_vpc_crn_account_b": permanentResources["tg_crossaccount_vpc_crn"],
		"resource_group_account_a":   options.ResourceGroup,
		"resource_group_account_b":   permanentResources["tg_crossaccount_rg"],
	}

	return options
}

func TestRunCrossaccountsExample(t *testing.T) {
	t.Parallel()

	options := setupOptionsCrossaccountsExample(t, "cross")

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func TestRunUpgradeExample(t *testing.T) {
	t.Parallel()

	options := setupOptions2VpcsPrefixFilterExample(t, "prupg-tg")

	output, err := options.RunTestUpgrade()
	if !options.UpgradeTestSkipped {
		assert.Nil(t, err, "This should not have errored")
		assert.NotNil(t, output, "Expected some output")
	}
}
