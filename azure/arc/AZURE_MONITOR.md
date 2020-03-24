# Azure Monitor

```bash
RG_NAME=AzureArcTest                                                                                             
WORKSPACE_NAME=rothiearcws
REGION=westeurope
CLUSTER_NAME=AzureArcTest1

# Create LogAnalytic workspace
az monitor log-analytics workspace create -g $RG_NAME -n $WORKSPACE_NAME

WORKSPACE_RESOURCE_ID=$(az monitor log-analytics workspace show -g $RG_NAME -n $WORKSPACE_NAME -o tsv --query id)
WORKSPACE_ID=$(az monitor log-analytics workspace show -g $RG_NAME -n $WORKSPACE_NAME -o tsv --query customerId)
WORKSPACE_KEY=$(az monitor log-analytics workspace get-shared-keys -g $RG_NAME -n $WORKSPACE_NAME --query primarySharedKey -o tsv)

# Add 'AzureMonitor-Containers' solution
az group deployment create \
  --resource-group $RG_NAME \
  --template-uri https://raw.githubusercontent.com/microsoft/OMS-docker/ci_feature_prod/docs/templates/azuremonitor-containerSolution.json \
  --parameters https://raw.githubusercontent.com/microsoft/OMS-docker/ci_feature_prod/docs/templates/azuremonitor-containerSolutionParams.json workspaceResourceId=$WORKSPACE_RESOURCE_ID workspaceRegion=$REGION

# Tag
az resource tag --tags logAnalyticsWorkspaceResourceId=$WORKSPACE_RESOURCE_ID -g $RG_NAME -n $CLUSTER_NAME --resource-type Microsoft.Kubernetes/connectedClusters

# Install
helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/
helm upgrade \
  --set omsagent.secret.wsid=$WORKSPACE_ID,omsagent.secret.key=$WORKSPACE_KEY,omsagent.env.clusterName=$CLUSTER_NAME \
  --install \
   azure-monitor-rothie incubator/azuremonitor-containers
```
