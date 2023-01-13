# dq-vault
Data Quality Observation of Data Vault layer.

[![ci_integration_tests](https://github.com/infinitelambda/dbt_dq_vault/actions/workflows/ci_integration_tests.yml/badge.svg)](https://github.com/infinitelambda/dbt_dq_vault/actions/workflows/ci_integration_tests.yml)

[![Netlify Status](https://api.netlify.com/api/v1/badges/9f262ea7-b556-4719-a176-572fc26d8da4/deploy-status)](https://app.netlify.com/sites/dq-vault/deploys)

**Installation**
```yaml
# package.yml - To be updated once package's published
packages:
  - package: <TBD>/dq_vault
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
In above:
- `dq_vault__enable_store_test`: bool
  - Set `true` to tell the package to capture the test results on the run end of dbt command. Default `false` not to do anything.
- `dq_vault__raw_db`: string
  - Configure the database where the raw test log table (`RAW_TEST`) is created
- `dq_vault__raw_schema`: string
  - Configure the schema where the raw test log table (`RAW_TEST`) is created
- `dq_vault__selected_model_rules`: list
  - Define the mapping for selecting the Data Vault models ONLY, currently relying on the model name. The order of item in the list does matter.

# Classify Test Type of your test cases
Currently there are 4 built-in test types based on the test name:
- Duplication: generic test name contains 'unique'
- Reconciliation: 
  - singular test
  - generic test name contains 'equality', 'equal'
- Reference: generic test name contains 'reference', 'relationship'
- Unknown: default test type

### Decide which test case belong to which test type:
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
Listing the custom built-in macros in the packages
#### get_datavault_type ([source](/macros/general/get_datavault_type.sql), [doc](https://dq-vault.netlify.app/#!/macro/macro.dq_vault.get_datavault_type))
#### get_test_type ([source](/macros/general/get_test_type.sql), [doc](https://dq-vault.netlify.app/#!/macro/macro.dq_vault.get_test_type))
#### where_select_dv_models ([source](/macros/general/where_select_dv_models.sql), [doc](https://dq-vault.netlify.app/#!/macro/macro.dq_vault.where_select_dv_models))
#### result_to_dict ([source](/macros/on-run-end/run-results/test/result_to_dict.sql), [doc](https://dq-vault.netlify.app/#!/macro/macro.dq_vault.result_to_dict))
#### store_test_results_json ([source](/macros/on-run-end/run-results/test/store_test_results_json.sql), [doc](https://dq-vault.netlify.app/#!/macro/macro.dq_vault.store_test_results_json))
#### get_raw_test ([source](/macros/resources/test/get_raw_test.sql), [doc](https://dq-vault.netlify.app/#!/macro/macro.dq_vault.get_raw_test))
#### create_resources ([source](/macros/resources/create_resources.sql), [doc](https://dq-vault.netlify.app/#!/macro/macro.dq_vault.create_resources))
#### refresh_resouces ([source](/macros/resources/refresh_resouces.sql), [doc](https://dq-vault.netlify.app/#!/macro/macro.dq_vault.refresh_resouces))

# Integration Tests
The `integration_tests` directory contains a dbt project which tests the macros/models/etc in the dq-vault package. An integration test typically involves making 1) a new seed file 2) a new model file 3) a generic test to assert anticipated behaviour.

For an example integration tests, check out the tests for the `get_datavault_type` macro:

1. [Macro definition](/macros/general/get_datavault_type.sql)
2. [Seed or Model file with fake data](/integration_tests/models/macros/general/test_get_datavault_type.sql)
3. [A generic test to assert the macro works as expected](/integration_tests/models/macros/general/general.yml)

Once you've added all of these files, you should be able to run:

Assuming you are in the `integration_tests` folder,
```bash
dbt deps --target {your_target}
dbt seed --target {your_target}
dbt run --target {your_target} --model {your_model_name}
dbt test --target {your_target} --model {your_model_name}
```

Alternatively, at the root repo folder (`/dq-vault`):
```bash
chmod +x run_test.sh
./run_test.sh {your_target} {your_models}
```
If the tests all pass, then you're good to go! All tests will be run automatically when you create a PR against this repo.


## Developer's Guide
- Quick Start (if you already setup the local dev):
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

- Prequisites:
    - Install Python 3.9.6+ as recommended (specified in [pyproject.toml](./pyproject.toml))
        > Assuming your python alias: `python3`

        > Don't need to use alias if your enviroment is not multi python version

    - Install `poetry`
    ```bash
    python3 -m pip install poetry
    ```

- Setup dev local enviroment
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

    Now, you can play with dbt as further!
    - Verify dbt installed version
        ```bash
        dbt --version
        ```
    - Copy [profiles](./ci/sample.profiles.yml) to '.dbt' dir (create if not exists) under the Users dir.
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
