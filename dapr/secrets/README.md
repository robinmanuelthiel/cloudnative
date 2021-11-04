# ![wemogy logo](https://wemogyimages.blob.core.windows.net/logos/wemogy-github-tiny.png) SecretsDemo

- [x] Run Dapr + Azure Key Vault locally
- [x] Run Dapr + Secrets file locally
- [x] Debug .NET App with Dapr in VS Code
- [ ] Run Dapr with Docker-Compose locally
- [ ] Debug Dapr with Docker-Compose locally
- [ ] Debug .NET App with Dapr in Rider
- [ ] Deploy to Kubernetes with Helm and AAD Pod Identity

## Steps

### Make sure, daprd is added to the path

```bash
echo "export PATH=$PATH:/$HOME/.dapr/bin" >> ~/.zshrc
```

### Create a Service Principal for development

```bash
APP_ID=$(az ad app create \
  --display-name "rothiesecretsdemo" \
  --available-to-other-tenants false \
  --oauth2-allow-implicit-flow false \
  | jq -r .appId)

PASSWORD=$(az ad app credential reset \
  --id "${APP_ID}" \
  --years 2 \
  --password $(openssl rand -base64 30) \
  | jq -r .password)

SERVICE_PRINCIPAL=$(az ad sp create --id "${APP_ID}")
SERVICE_PRINCIPAL_ID=$(echo "$SERVICE_PRINCIPAL" | jq -r .objectId)
SERVICE_PRINCIPAL_TENANT_ID=$(echo "$SERVICE_PRINCIPAL" | jq -r .tenant)
```

### Upload the Password and Client ID

```bash
az keyvault secret set \
  --vault-name rothiesecretsdemoglobal \
  --name "DevAppId" \
  --value "${APP_ID}"

az keyvault secret set \
  --vault-name rothiesecretsdemoglobal \
  --name "DevAppServicePrincipalTenantId" \
  --value "${SERVICE_PRINCIPAL_TENANT_ID}"

az keyvault secret set \
  --vault-name rothiesecretsdemoglobal \
  --name "DevAppServicePrincipalPassword" \
  --value "${PASSWORD}"
```

### Grant access to Dev Azure KeyVault

```bash
az keyvault set-policy \
  --name rothiesecretsdemovault \
  --object-id ${SERVICE_PRINCIPAL_ID} \
  --secret-permissions get list
```

## Container images

```bash
docker buildx build --push --tag robinmanuelthiel/dapr-secrets-demo:latest -f src/SecretsDemo/Dockerfile  .
```
