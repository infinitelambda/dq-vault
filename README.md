# dq-vault
This DBT package provides an overview on Data Quality for all DataVault (DV) models in your DBT project.

[![ci_integration_tests](https://github.com/infinitelambda/dq-vault/actions/workflows/ci_integration_tests.yml/badge.svg)](https://github.com/infinitelambda/dq-vault/actions/workflows/ci_integration_tests.yml)

[![Publish dbt Documentation on Release](https://github.com/infinitelambda/dq-vault/actions/workflows/cd_dbt_docs.yml/badge.svg)](https://github.com/infinitelambda/dq-vault/actions/workflows/cd_dbt_docs.yml)

`dq-vault` enables you to:
- Monitor your test coverage for DV models
- Monitor no. of tests are there for each model or each DV entity (Hub, Link, Satellite ...)
- Be aware of tests that fail or throw warnings frequently
- Compare the number of warnings/errors/test failures between each DBT run


## What does this package do?
It works by scanning your DBT test run results related to DataVault models and putting them into the following `views` & `metrics`:
- Views:
  - `dim_dv_test`: information on all your available DBT tests (test name, test tag, which model or column it's assigned to ...)
  - `dim_dv_test_execution`: details on each test run (execution time, run id, test name, status, failed rows count, test message ...)
  - `fact_dv_tests`: a combined view of `dim_dv_test` and `dim_dv_test_execution`
  - `fact_dv_tests_unnest_models`: `fact_dv_tests` but on the granularity of referenced models in each test
- Metrics:
  - `average_test_execution_time`
  - `no_of_test_of_each_model`
  - `no_of_test_of_each_run`
  - `test_status_of_each_run`

## What are the requirements to use this package?
A DBT project with:
- DataVault models' names that match `dq_vault__selected_model_rules` below (the rules are configurable)
- DBT tests for the mentioned models

**Installation**
```yaml
packages:
  - package: infinitelambda/dq_vault
    version: [">=0.1.0", "<1.0.0"]
```

```yaml
# dbt_project.yml
on-run-end:
  - '{{ dq_vault.store_test_results_json(results) }}'
```

# Variables
```yaml
vars:
  dq_vault__enable_store_test: true or false
  dq_vault__raw_db: 'your_custom_db or target.database'
  dq_vault__raw_schema: 'your_custom_schema or target.schema'
  dq_vault__selected_model_rules:
    - hub: ['hub']
    - sat: ['sat','satellite']
    - link: ['link','tlink','t_link','lnk','tlnk','t_lnk']
    - pit: ['pit']
    - bridge: ['bridge']
    - xts: ['xts']
```
In the above:
- `dq_vault__enable_store_test`: bool
  - Set as `true` to capture test results on the run-end of dbt command. Default `false`.
- `dq_vault__raw_db`: string
  - Configure the DATABASE for the raw test log table (`RAW_TEST`)
- `dq_vault__raw_schema`: string
  - Configure the SCHEMA for the raw test log table (`RAW_TEST`)
- `dq_vault__selected_model_rules`: list
  - Define the mapping for Data Vault model selection based on model names. The order of rules in the list determines the priority of classification.
  - For example, with the default rules list ordered as above: 
    - Model `random_sample_hub.sql` will be classified as `HUB`
    - Model `this_sample_tlink` will be classified as `LINK`
    - Model `sample_SAT_hub.sql` will also be classified as `HUB` and not `SAT`, because the hub rule ranks 1st in the rules list.

# Classify the Test Type of your test cases
Currently, there are 4 built-in test types based on the test name:
- Duplication: Generic tests' names that contain `unique`
- Reconciliation: 
  - Singular tests
  - Generic tests' names that contain the following: `equality`, `equal`
- Reference: Generic tests' names that contain the following: `reference`, `relationship`
- Unknown: default test type

### Labeling test type for each test case:
  - Using test config
  ```yaml
  models:
    - name: my_model
      tests:
        - my_test:
            test_type: duplication
  ```
  - Using test meta
  ```yaml
  models:
    - name: my_model
      tests:
        - my_test:
            meta:
              test_type: duplication
  ```


# Macros
List of custom built-in macros in this package:

#### store_test_results_json ([source](https://github.com/infinitelambda/dq-vault/blob/main/macros/on-run-end/run-results/test/store_test_results_json.sql), [doc](https://dq-vault.netlify.app/#!/macro/macro.dq_vault.store_test_results_json))

#### get_datavault_type ([source](https://github.com/infinitelambda/dq-vault/blob/main/macros/general/get_datavault_type.sql), [doc](https://dq-vault.netlify.app/#!/macro/macro.dq_vault.get_datavault_type))

#### get_test_type ([source](https://github.com/infinitelambda/dq-vault/blob/main/macros/general/get_test_type.sql), [doc](https://dq-vault.netlify.app/#!/macro/macro.dq_vault.get_test_type))

#### where_select_dv_models ([source](https://github.com/infinitelambda/dq-vault/blob/main/macros/general/where_select_dv_models.sql), [doc](https://dq-vault.netlify.app/#!/macro/macro.dq_vault.where_select_dv_models))

#### result_to_dict ([source](https://github.com/infinitelambda/dq-vault/blob/main/macros/on-run-end/run-results/test/result_to_dict.sql), [doc](https://dq-vault.netlify.app/#!/macro/macro.dq_vault.result_to_dict))

#### get_raw_test ([source](https://github.com/infinitelambda/dq-vault/blob/main/macros/resources/test/get_raw_test.sql), [doc](https://dq-vault.netlify.app/#!/macro/macro.dq_vault.get_raw_test))

#### create_resources ([source](https://github.com/infinitelambda/dq-vault/blob/main/macros/resources/create_resources.sql), [doc](https://dq-vault.netlify.app/#!/macro/macro.dq_vault.create_resources))

#### refresh_resouces ([source](https://github.com/infinitelambda/dq-vault/blob/main/macros/resources/refresh_resouces.sql), [doc](https://dq-vault.netlify.app/#!/macro/macro.dq_vault.refresh_resouces))

# Integration Tests
The `integration_tests` directory contains a DBT project that tests the macros/models/etc in this dq-vault package. 
An integration test typically involves making 1- a new seed file; 2- a new model file; 3- a generic test to assert anticipated behavior.

For an example on integration tests, check out the tests for `get_datavault_type` macro:

1. [Macro definition](https://github.com/infinitelambda/dq-vault/blob/main/macros/general/get_datavault_type.sql)
2. [Seed or Model file with fake data](https://github.com/infinitelambda/dq-vault/blob/main/integration_tests/models/macros/general/test_get_datavault_type.sql)
3. [A generic test to assert the macro works as expected](https://github.com/infinitelambda/dq-vault/blob/main/integration_tests/models/macros/general/general.yml)

Once you've added all of these files, you should be able to run:

Make sure you are currently in the `integration_tests` folder,
```bash
dbt deps --target {your_target}
dbt seed --target {your_target}
dbt run --target {your_target} --model {your_model_name}
dbt test --target {your_target} --model {your_model_name}
```
Note: You might see some `Failure` and `Warning` while running tests for models specified in `integration_tests`. 
This is a part of this package testing and is completely normal.
For the current version, running `dbt build` inside `integration_tests` will yield `Completed with 10 errors and 3 warnings`

Alternatively, at the repo's root (`/dq-vault`):
```bash
chmod +x run_test.sh
./run_test.sh {your_target} {your_models}
```
Once all the tests are passed you're good to go! All tests will be run automatically when you create a PR against this repo.


## Developer's Guide
- Quick Start (if you already setup the local dev, if not see the local dev setting up section below):
    - Start the shell
        ```bash
        cd /path/to/dq-vault/integration_tests
        python3 -m poetry shell
        ```
    - Some sample commands:
        ```bash
        # Build model and capture test result - with refresh the resources (raw_tests table)
        dbt build --exclude source:run_result_log+ tag:failed tag:sample_custom --vars '{dq_vault__enable_store_test: true, fresh: true}'
        # Build integration test/models with potential failed cases
        dbt build --select tag:failed tag:sample_custom --vars '{dq_vault__enable_store_test: true}'
        # Build dq vault main models - downstream of test result log table
        dbt build --select source:run_result_log+
        ```

- Prerequisites:
    - Install Python 3.9.6+ as recommended (specified in [pyproject.toml](./pyproject.toml))
        > Assuming your python alias: `python3`

        > Don't need to use an alias if your environment is not multi python version

    - Install `poetry`
    ```bash
    python3 -m pip install poetry
    ```

- Setup dev local environment
    1. Set working dir
    ```bash
    cd /path/to/dq-vault
    ```
    2. Install dependencies
    ```bash
    python3 -m poetry install
    ```
    3. Start shell (equivalent to activate virtualenv)
    ```bash
    python3 -m poetry shell
    ```
    4. Install dev dependencies
    ```bash
    poe git-hooks
    # Yes, it's poe, it's not a spelling mistake :)
    ```

    Now you can set up your DBT:
    - Verify dbt installed version
        ```bash
        dbt --version
        ```
    - Copy [profiles](https://github.com/infinitelambda/dq-vault/blob/main/integration_tests/ci/sample.profiles.yml) to '.dbt' dir (create if not exists) under the Users dir.
        ```bash
        # Linux/MacOs
        mkdir ~/.dbt > /dev/null
        cp ./profiles/profiles.yml ~/.dbt/profiles.yml
        ```
        NOTE: To simplify the dev, here we update the real `password` value (not using `env_vars`) in the profiles.yml after copying

    - Check dbt configs:
        ```bash
        cd integration_tests
        dbt debug [--profiles-dir /path/to/profiles-dir]
        ```
    - Run your model
        ```bash
        dbt deps
        dbt seed
        dbt run
        ```

    To exit the shell:
    ```bash
    exit
    # Enter
    ```
