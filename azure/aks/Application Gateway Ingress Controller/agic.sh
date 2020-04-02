#!/bin/sh
SUBSCRIPTION_ID=$1
RESOURCE_GROUP=$2
APPLICATION_GATEWAY_NAME=$3
IDENTITY_NAME=$4

IDENTITY_RESOURCE_ID=/subscriptions/$SUBSCRIPTION_ID/resourcegroups/$RESOURCE_GROUP/providers/Microsoft.ManagedIdentity/userAssignedIdentities/$IDENTITY_NAME
IDENTITY_CLIENT_ID=$(az identity show -n $IDENTITY_NAME -g $RESOURCE_GROUP --query clientId -o tsv)
APPLICATION_GATEWAY_RESOURCE_ID=/subscriptions/$SUBSCRIPTION_ID/resourcegroups/$RESOURCE_GROUP/providers/Microsoft.Network/applicationGateways/$APPLICATION_GATEWAY_NAME
RESOURCE_GROUP_RESOURCE_ID=/subscriptions/$SUBSCRIPTION_ID/resourcegroups/$RESOURCE_GROUP

# Role Assignments
az role assignment create \
  --assignee $IDENTITY_CLIENT_ID \
  --role "Contributor" \
  --scope $APPLICATION_GATEWAY_RESOURCE_ID

az role assignment create \
  --assignee $IDENTITY_CLIENT_ID \
  --role "Reader" \
  --scope $RESOURCE_GROUP_RESOURCE_ID

# Create a Kubernetes namespace
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:  
  name: application-gateway-ingress-controller
EOF

# Prepare Helm
helm repo add application-gateway-kubernetes-ingress https://appgwingress.blob.core.windows.net/ingress-azure-helm-package/
helm repo update

# Install AGIC
helm upgrade application-gateway-ingress-controller application-gateway-kubernetes-ingress/ingress-azure \
  --install \
  --namespace application-gateway-ingress-controller \
  --set appgw.subscriptionId=$SUBSCRIPTION_ID \
  --set appgw.resourceGroup=$RESOURCE_GROUP \
  --set appgw.name=$APPLICATION_GATEWAY_NAME \
  --set appgw.usePrivateIP=false \
  --set appgw.shared=false \
  --set armAuth.type=aadPodIdentity \
  --set armAuth.identityResourceID=$IDENTITY_RESOURCE_ID \
  --set armAuth.identityClientID=$IDENTITY_CLIENT_ID \
  --set kubernetes.watchNamespace=default \
  --set rbac.enabled=true

# CURRENTLY BLOCKED BY https://github.com/Azure/application-gateway-kubernetes-ingress/issues/788
