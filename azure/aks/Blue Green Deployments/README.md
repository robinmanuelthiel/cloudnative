# Blue / Green Deployments

## Get currently active environment

### CLI

```bash
ACTIVE_POOL_ID=$(az network application-gateway rule show \
  --gateway-name appgateway \
  --resource-group rothiebluegreen \
  --name active \
  --query backendAddressPool.id \
  --output tsv)

ACTIVE_POOL_NAME=$(az network application-gateway address-pool list \
  --gateway-name appgateway \
  --resource-group rothiebluegreen \
  --query "[?id=='$ACTIVE_POOL_ID'].name" \
  --output tsv)

echo "Your currently active environment is $ACTIVE_POOL_NAME."
```

## Switch between environments

### CLI

```bash
az network application-gateway rule update \
  --gateway-name appgateway \
  --resource-group rothiebluegreen \
  --name active \
  --address-pool green
```

### Terraform

```bash
terraform apply -var 'active_environment=green'
```
