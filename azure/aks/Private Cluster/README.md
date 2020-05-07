# Private Clusters

1. Create a fully private AKS cluster which deploys into a VNET (see Terrafrom script)
1. Deploy an additional Virtual Machine to access the Kubernetes API into the same VNET (use Certificate authentication)
1. Deploy an Azure Bastion host to access the VM into the same VNET
1. In the `MC_` resource group
   1. Select the Private DNS Zone and create a link with the VM VNET
   1. Select the VNET and peer it with the VM VNET
