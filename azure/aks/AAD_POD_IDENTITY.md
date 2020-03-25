# Azure Active Directory Pod Identity


```bash
cat <<EOF | kubectl apply -f -
apiVersion: "aadpodidentity.k8s.io/v1"
kind: AzureIdentity
metadata:
  name: aad-pod-identity
spec:
  type: 0
  ResourceID: /subscriptions/<SUBSCRIPTION_ID>/resourcegroups/<RESOURCE_GROUP>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<IDENTITY_NAME>
  ClientID: <IDENTITY_CLIENT_ID>
---
apiVersion: "aadpodidentity.k8s.io/v1"
kind: AzureIdentityBinding
metadata:
  name: aad-pod-identity-binding
spec:
  AzureIdentity: aad-pod-identity
  Selector: aad-pod-identity
EOF
```
