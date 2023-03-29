package test

import (
	"fmt"
	"log"
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/cloudinfo"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
	"gopkg.in/yaml.v2"
)

const resourceGroup = "geretain-test-transit-gw"

var sharedInfoSvc *cloudinfo.CloudInfoService

// Define a struct with fields that match the structure of the YAML data
const yamlLocation = "../common-dev-assets/common-go-assets/common-permanent-resources.yaml"

// config parameters definition
type Config struct {
	GeStagingVpcCrn    string `yaml:"gestaging_vpc_crn"`
	GeStagingRgName    string `yaml:"gestaging_rg"`
	GeStagingVpcRegion string `yaml:"gestaging_vpc_region"`
}

var geStagingVpcCrn string
var geStagingRgName string
var geStagingVpcRegion string

// Runs before any parallel tests, used to set up a shared InfoService object to track region usage
func TestMain(m *testing.M) {
	sharedInfoSvc, _ = cloudinfo.NewCloudInfoServiceFromEnv("TF_VAR_ibmcloud_api_key", cloudinfo.CloudInfoServiceOptions{})

	// Read the YAML file contents
	data, err := os.ReadFile(yamlLocation)
	if err != nil {
		log.Fatal(err)
	}
	// Create a struct to hold the YAML data
	var config Config
	// Unmarshal the YAML data into the struct
	err = yaml.Unmarshal(data, &config)
	if err != nil {
		log.Fatal(err)
	}
	// Parse the gestaging_vpc_crn to use in the test
	geStagingVpcCrn = config.GeStagingVpcCrn
	geStagingRgName = config.GeStagingRgName
	geStagingVpcRegion = config.GeStagingVpcRegion
	log.Output(1, "TestMain using geStagingVpcCrn "+geStagingVpcCrn)
	log.Output(1, "TestMain using geStagingVpcCrn "+geStagingRgName)
	log.Output(1, "TestMain using geStagingVpcRegion "+geStagingVpcRegion)

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

func setupOptionsCrossaccountsExample(t *testing.T, prefix string) *testhelper.TestOptions {
	const TwoVpcsExampleTerraformDir = "examples/crossaccounts"

	options := testhelper.TestOptionsDefault(&testhelper.TestOptions{
		Testing:       t,
		Prefix:        prefix,
		DefaultRegion: geStagingVpcRegion, // using target account region as default one
		TerraformDir:  TwoVpcsExampleTerraformDir,
		ResourceGroup: resourceGroup,
	})

	options.TerraformVars = map[string]interface{}{
		"transit_gateway_name": fmt.Sprintf("%s-%s", prefix, "crosstg"),
		// using the same region of the target account
		"region_a": geStagingVpcRegion,
		"region_b": geStagingVpcRegion,
		"prefix_a": fmt.Sprintf("%s-%s", prefix, "a"),
		// using existing vpc crn
		"existing_vpc_crn_b": geStagingVpcCrn,
		"resource_group_a":   options.ResourceGroup,
		"resource_group_b":   geStagingRgName,
	}

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

func TestRunCrossaccountsExample(t *testing.T) {
	// the test performs two runs of init&apply due to the bug of the provider
	// https://github.com/IBM-Cloud/terraform-provider-ibm/issues/4445
	// the first run creates the resources without approving the connection
	// the second run performs an approve on the connection request
	t.Parallel()

	options := setupOptionsCrossaccountsExample(t, "cross")
	options.SkipTestTearDown = true
	// first run disabled approval
	options.TerraformVars["run_approval"] = false
	log.Output(1, "Performing first run with approval disabled")
	output, err := options.RunTestConsistency()
	// deferring TestTearDown to have it to run whatever happens during execution
	defer options.TestTearDown()
	if err != nil {
		fmt.Println("Error happened during the first run", err)
	} else {
		log.Output(1, "Completed first run with approval disabled")

		assert.Nil(t, err, "This should not have errored")
		assert.NotNil(t, output, "Expected some output")

		options.TerraformVars["run_approval"] = true
		log.Output(1, "Performing second run with approval enabled")

		output2, err2 := terraform.InitAndApplyE(options.Testing, options.TerraformOptions)
		if err2 != nil {
			fmt.Println("Error happened during the second run", err2)
		} else {
			log.Output(1, "Completed second run with approval enabled")
			assert.Nil(t, err2, "This should not have errored")
			assert.NotNil(t, output2, "Expected some output")
		}
	}
}

func TestRunUpgradeExample(t *testing.T) {
	t.Parallel()

	options := setupOptionsBasicExample(t, "ibm-tgn")

	output, err := options.RunTestUpgrade()
	if !options.UpgradeTestSkipped {
		assert.Nil(t, err, "This should not have errored")
		assert.NotNil(t, output, "Expected some output")
	}
}
