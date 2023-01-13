#!/bin/bash

# Show location of local install of dbt
echo $(which dbt)

# Show version and installed adapters
dbt --version

# Set the profile
cd integration_tests
cp ci/sample.profiles.yml profiles.yml
export DBT_PROFILES_DIR=.

# Show the location of the profiles directory and test the connection
dbt debug --target $1

# Select model to run (if any) e.g. `./run_test.sh snowflake +my_model`
_models=""
if [[ ! -z $2 ]]; then _models="--select $2"; fi

# Install dbt packages
dbt deps --target $1 || exit 1

# Build model and capture test result - with refresh the resources (raw_tests table)
dbt build --exclude source:run_result_log+ tag:failed tag:sample_custom --vars '{dq_vault__enable_store_test: true, fresh: true}'
# Build integration test/models with potential failed cases
{ # try
  dbt build --select tag:failed tag:sample_custom --vars '{dq_vault__enable_store_test: true}'
} || { # catch
  echo "Force skip"
}
# Build dq vault main models - downstream of test result log table
dbt build --select source:run_result_log+