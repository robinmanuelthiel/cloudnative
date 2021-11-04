#!/bin/bash

devAppId=$(az keyvault secret show --vault-name rothiesecretsdemoglobal --name DevAppId --query value -o tsv)
devAppServicePrincipalTenantId=$(az keyvault secret show --vault-name rothiesecretsdemoglobal --name DevAppServicePrincipalTenantId --query value -o tsv)
devAppServicePrincipalPassword=$(az keyvault secret show --vault-name rothiesecretsdemoglobal --name DevAppServicePrincipalPassword --query value -o tsv)

jq \
  --arg key0 "DevAppId" \
  --arg value0 $devAppId \
  --arg key1 "DevAppServicePrincipalTenantId" \
  --arg value1 $devAppServicePrincipalTenantId \
  --arg key2 "DevAppServicePrincipalPassword" \
  --arg value2 $devAppServicePrincipalPassword \
  '. | .[$key0]=$value0 | .[$key1]=$value1 | .[$key2]=$value2' \
  <<<'{}' \
  > ../dapr/secrets/secrets.json
