# Azure KeyVault CSI Driver

This demo uses the Azure KeyVault CSI Driver for Kubernetes to demonstrate the following:

- Authenticate against Azure KeyVault using AAD Pod Identity
- Mount a Secret into a Pod
- Use a self-signed certifcate for an NGINX ingress controller

## Get it running

Login to your Azure Account.

```bash
az login
```

Setup the infrastructure with Terraform from the `/terraform` folder.

```bash
terraform init

terraform apply -auto-approve
```

Login to the cluster

```bash
az aks get-credentials -g <RESOURCE_GROUP> -n <CLUSTER_NAME>
```

Set Pod Security Policies according to the [Azure KeyVault CSI Driver documentation](https://azure.github.io/secrets-store-csi-driver-provider-azure/getting-started/installation/#using-deployment-yamls).

```bash
kubectl apply -f https://raw.githubusercontent.com/Azure/secrets-store-csi-driver-provider-azure/master/deployment/pod-security-policy.yaml
```

Setup the Kubernetes Cluster from the `/kubernetes` folder.

```bash
kubectl apply -f .
```
