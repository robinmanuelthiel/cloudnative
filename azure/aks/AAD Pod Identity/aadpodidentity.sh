#!/bin/sh
# xyz.sh <SUBSCRIPTION_ID> <RESOURCE_GROUP> <IDENTITY_NAME> <AKS_NAME>

SUBSCRIPTION_ID=$1
RESOURCE_GROUP=$2
IDENTITY_NAME=$3
AKS_NAME=$4

IDENTITY_CLIENT_ID=$(az identity show -n $IDENTITY_NAME -g $RESOURCE_GROUP --query clientId -o tsv)
IDENTITY_RESOURCE_ID=$(az identity show -n $IDENTITY_NAME -g $RESOURCE_GROUP --query id -o tsv)
AKS_SERIVCE_PRINCIPAL_CLIENT_ID=$(az aks show -g $RESOURCE_GROUP -n $AKS_NAME --query servicePrincipalProfile.clientId -o tsv)

# Role Assignments
az role assignment create \
  --assignee $IDENTITY_CLIENT_ID \
  --role "Managed Identity Operator" \
  --scope $IDENTITY_RESOURCE_ID

# Create a Kubernetes namespace
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:  
  name: aad-pod-identity
EOF

# Prepare Helm
helm repo add aad-pod-identity https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts
helm repo update

# Install AAD Pod Identity
helm upgrade aad-pod-identity aad-pod-identity/aad-pod-identity \
  --install \
  --namespace aad-pod-identity

# Add Identity and Binding
cat <<EOF | kubectl apply -f -
apiVersion: "aadpodidentity.k8s.io/v1"
kind: AzureIdentity
metadata:
  name: $IDENTITY_NAME
spec:
  type: 0
  ResourceID: /subscriptions/$SUBSCRIPTION_ID/resourcegroups/$RESOURCE_GROUP/providers/Microsoft.ManagedIdentity/userAssignedIdentities/$IDENTITY_NAME
  ClientID: $IDENTITY_CLIENT_ID
---
apiVersion: "aadpodidentity.k8s.io/v1"
kind: AzureIdentityBinding
metadata:
  name: $IDENTITY_NAME-binding
spec:
  AzureIdentity: $IDENTITY_NAME
  Selector: $IDENTITY_NAME
EOF
