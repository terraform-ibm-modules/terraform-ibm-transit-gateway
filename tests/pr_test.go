package test

import (
	"fmt"
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/cloudinfo"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
)

const basicExampleTerraformDir = "examples/tg-gateway-connection"
const resourceGroup = "geretain-test-observability-instances"

var vpcConnections []string

var sharedInfoSvc *cloudinfo.CloudInfoService

// TestMain will be run before any parallel tests, used to set up a shared InfoService object to track region usage
// for multiple tests.
// There is new feature in terratest-wrapper that will keep Activity Tracker tests on unique regions to avoid conflicts,
// and using a shared InfoService will allow this feature to work between multiple tests running in parallel.
func TestMain(m *testing.M) {
	sharedInfoSvc, _ = cloudinfo.NewCloudInfoServiceFromEnv("TF_VAR_ibmcloud_api_key", cloudinfo.CloudInfoServiceOptions{})

	os.Exit(m.Run())
}

/*
*********************************************
NOTE: this private function "setupOptions" is not required.
It helps if you have several tests that will all use a very similar
set of options.
If you have a test that uses a different set of options you can set those
up in the individual test.
***********************************************
*/
func setupOptions(t *testing.T, prefix string) *testhelper.TestOptions {

	options := testhelper.TestOptionsDefault(&testhelper.TestOptions{
		Testing:                       t,
		TerraformDir:                  basicExampleTerraformDir,
		Prefix:                        prefix,
		ResourceGroup:                 resourceGroup,
		ExcludeActivityTrackerRegions: true,          // do not select regions that already have an AT
		CloudInfoService:              sharedInfoSvc, // use pointer to shared info svc to keep track of region seleections
		DefaultRegion:                 "us-south",
	})

	// default options will take care of selecting a good first region, but this test needs a 2nd region for super tenents.
	// this extra block will select a 2nd region, and due to using a shared Info Service it will select a different region than
	// the default options selection, or any other parallel test runs.
	regionOptions := &testhelper.TesthelperTerraformOptions{
		ExcludeActivityTrackerRegions: true,          // do not select regions that already have an AT
		CloudInfoService:              sharedInfoSvc, // use pointer to shared info svc to keep track of region seleections
	}
	region2, _ := testhelper.GetBestVpcRegionO(options.RequiredEnvironmentVars["TF_VAR_ibmcloud_api_key"], "../common-dev-assets/common-go-assets/cloudinfo-region-vpc-gen2-prefs.yaml", "us-east", *regionOptions)

	options.TerraformVars = map[string]interface{}{
		"resource_group_name":       options.ResourceGroup,
		"transit_gateway_name":      fmt.Sprintf("%s-%s", options.Prefix, "tg"),
		"location":                  region2,
		"vpc_connections":           vpcConnections,
		"classic_connections_count": 0,
	}

	return options
}

/*
******************************************************
This will run the basic example using two different regions for AT
(one for std and one for sts).
The test will apply the example, then an immediate plan and check
if there are no further changes to apply (idempotent check).
*******************************************************
*/
func TestRunBasicExample(t *testing.T) {
	t.Parallel()

	options := setupOptions(t, "ibm-kms-key")

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

/*
******************************************************
This will run an UPGRADE test on the basic example using two
different regions for AT (one for std and one for sts) and
also different than the standard test to avoid region conflicts.

The upgrade test will check out the "main" branch, run apply,
then check out the PR branch and run a plan. If there are any
changes that would result in destruction of resources it will fail,
warning the developers that the PR may contain a breaking change.

NOTE: This upgrade test will be skipped if the go test is run with
the "-short" option, or if any commit messages in the PR branch contain
the "BREAKING CHANGE" text.
*******************************************************
*/
func TestRunUpgradeExample(t *testing.T) {
	t.Parallel()

	options := setupOptions(t, "ibm-kms-key-upg")

	output, err := options.RunTestUpgrade()
	if !options.UpgradeTestSkipped {
		assert.Nil(t, err, "This should not have errored")
		assert.NotNil(t, output, "Expected some output")
	}
}
