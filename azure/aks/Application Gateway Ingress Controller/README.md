# Azure Application Gateway Ingress Controller

## Prerequisites

- Helm installed
- A Virtual Network with at least two subnets
  - One for the Kubernetes Cluster
  - One for the Azure Application Gateway
- An Azure Application Gateway deployed to the the Virtual Network
- An Azure Kubernetes Service (AKS) cluster deployed to the the Virtual Network
  - With Azure CNI Network Plugin (Advanced Networking)
- A Managed Identity
- [AAD Pod Identity](https://github.com/Azure/aad-pod-identity) installed into the cluster
  
## 1. Create Role Assignments

We will use the Managed Identity to authenticate against out Azure Subscription and configure Azure Application Gateway for us. For that, we need to give this Managed Identity **Contributor** permissons to the Application Gateway in **Reader** permissions to the Application Gateway's Resource Group.

```bash
az role assignment create \
  --assignee <MANAGED_IDENTITY_CLIENT_ID> \
  --role "Contributor" \
  --scope /subscriptions/<SUBSCRIPTION_ID>/resourcegroups/<RESOURCE_GROUP>/providers/Microsoft.Network/applicationGateways/<APPLICATION_GATEWAY_NAME>
```

```bash
az role assignment create \
  --assignee <MANAGED_IDENTITY_CLIENT_ID> \
  --role "Reader" \
  --scope /subscriptions/<SUBSCRIPTION_ID>/resourcegroups/<RESOURCE_GROUP>
```

## 2. Deploy Application Gateway Ingress Controller with Helm

Create a Kubernetes namespace for the Application Gateway Ingress Controller

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:  
  name: application-gateway-ingress-controller
EOF
```

Add the Azure Application Gateway Ingress Controller Helm repository

```bash
helm repo add application-gateway-kubernetes-ingress https://appgwingress.blob.core.windows.net/ingress-azure-helm-package/
helm repo update
```

Install the Helm chart

```bash
helm upgrade application-gateway-ingress-controller application-gateway-kubernetes-ingress/ingress-azure \
  --install \
  --namespace application-gateway-ingress-controller \
  --set appgw.subscriptionId=<SUBSCRIPTION_ID> \
  --set appgw.resourceGroup=<RESOURCE_GROUP> \
  --set appgw.name=<APPLICATION_GATEWAY_NAME> \
  --set appgw.usePrivateIP=false \
  --set appgw.shared=false \
  --set armAuth.type=aadPodIdentity \
  --set armAuth.identityResourceID=/subscriptions/<SUBSCRIPTION_ID>/resourcegroups/<RESOURCE_GROUP>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<MANGAGED_IDENTITY_NAME> \
  --set armAuth.identityClientID=<MANAGED_IDENTITY_CLIENT_ID> \
  --set kubernetes.watchNamespace=default \
  --set rbac.enabled=true
```
