# Node Public IP

[Documentation](https://docs.microsoft.com/en-us/azure/aks/use-multiple-node-pools#assign-a-public-ip-per-node-for-your-node-pools-preview)

Public Node IPs in AKS is still a Preview Feature. So we need to register this preview in our Subscription first.

```bash
az feature register --name NodePublicIPPreview --namespace Microsoft.ContainerService
```

## 1. Create an AKS cluster with Node Public IP on

```bash
terraform init

terraform apply
```

## 2. Deploy a test pod

We want to let the pod find out, what's his node's public IP.

```bash
# Login to the cluster
az aks get-credentials -g rothieaksnodeip -n aks
```

```bash
# Deploy a test pod
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: nginx-test
  labels:
    name: nginx-test
spec:
  containers:
  - name: nginx-test
    image: nginx
    env:
    - name: NODE_PRIVATE_IP
      valueFrom:
        fieldRef:
          fieldPath: status.hostIP
    - name: NODE_NAME
      valueFrom:
        fieldRef:
          fieldPath: spec.nodeName
    resources:
      limits:
        memory: "128Mi"
        cpu: "500m"
EOF
```

## Get the Node Public IP from within the pod

Currently during the Preview Phase of that feature, Kubernetes can't retrieve the public IP address of the node. So our only way to find that out, is asking the Azure API for the Public IP Address assinged to the VMSS member with the Node Name from the Pod's environment variables.

```bash
# Get the Pod's environemnt variabeles, which include the node name
kubectl exec nginx-test -- printenv
```

```bash
# Ask Azure for the IP address of that node name
NODE_NAME=aks-default-35064155-vmss000000
VM_ID=$(az vmss list-instances -g MC_rothieaksnodeip_aks_westeurope -n aks-default-35064155-vmss --query "[?osProfile.computerName=='$NODE_NAME'].id" -o tsv)
PUBLIC_IP=$(az vmss list-instance-public-ips -g MC_rothieaksnodeip_aks_westeurope -n aks-default-35064155-vmss --query "[?contains(id, '$VM_ID')].ipAddress" -o tsv)
echo $PUBLIC_IP
```
