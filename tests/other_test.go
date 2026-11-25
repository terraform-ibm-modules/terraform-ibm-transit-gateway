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
