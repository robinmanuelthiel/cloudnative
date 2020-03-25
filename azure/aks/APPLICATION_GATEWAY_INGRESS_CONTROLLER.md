# Azure Application Gateway Ingress Controller

## Prerequisites

- Helm
- A Virtual Network
- An Azure Application Gateway Inside the Virtual Network # TODO: Add steps
- An AKS Cluster
  - With CNI Network Plugin
  - Deployed into the Virtual Network
  - [AAD Pod Identity](https://github.com/Azure/aad-pod-identity) enabled
  
## X. Create Role Assignments

```bash
POD_IDENTITY_OBJECT_ID=

# Network Contributor Role
az role assignment create \
  --assignee $AKS_CLIENT_ID \
  --role "Azure Kubernetes Service Cluster User Role" \
  --scope $AKS_ID
```

## X. Deploy Application Gateway Ingress Controller

```bash
helm repo add application-gateway-kubernetes-ingress https://appgwingress.blob.core.windows.net/ingress-azure-helm-package/
helm repo update

helm upgrade agic application-gateway-kubernetes-ingress/ingress-azure \
  --install \
  --namespace agic
  --set appgw.subscriptionId=<SUBSCRIPTION_ID> \
  --set appgw.resourceGroup= \
  --set appgw.name= \
  --set armAuth.type=aadPodIdentity \
  --set armAuth.identityResourceID= \
  --set armAuth.identityClientID= \
  --set kubernetes.watchNamespace=default,kube-system \
  --set rbac.enabled=true
```
