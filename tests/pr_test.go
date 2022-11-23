package test

import (
	"fmt"
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/cloudinfo"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
)

const resourceGroup = "geretain-test-transit-gw"

var sharedInfoSvc *cloudinfo.CloudInfoService

// Runs before any parallel tests, used to set up a shared InfoService object to track region usage
func TestMain(m *testing.M) {
	sharedInfoSvc, _ = cloudinfo.NewCloudInfoServiceFromEnv("TF_VAR_ibmcloud_api_key", cloudinfo.CloudInfoServiceOptions{})

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
		TerraformVars: map[string]interface{}{
			"transit_gateway_name":      fmt.Sprintf("%s-%s", prefix, "tg"),
			"vpc_connections":           vpcConnections,
			"classic_connections_count": 0,
		},
		TerraformDir: basicExampleTerraformDir,
	})

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
		TerraformVars: map[string]interface{}{
			"transit_gateway_name": fmt.Sprintf("%s-%s", prefix, "tg"),
		},
		TerraformDir: TwoVpcsExampleTerraformDir,
	})

	return options
}

func TestRunBasicExample(t *testing.T) {
	t.Parallel()

	options := setupOptionsBasicExample(t, "ibm-tg")

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

func TestRunUpgradeExample(t *testing.T) {
	t.Parallel()

	// TODO: Remove this line after the first merge to primary branch is complete to enable upgrade test
	t.Skip("Skipping upgrade test until initial code is in primary branch")

	options := setupOptionsBasicExample(t, "ibm-tgn")

	output, err := options.RunTestUpgrade()
	if !options.UpgradeTestSkipped {
		assert.Nil(t, err, "This should not have errored")
		assert.NotNil(t, output, "Expected some output")
	}
}
