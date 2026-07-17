# Commands Used

No CLI commands were used.

This task was completed using the Azure Portal.

## Azure CLI Equivalent

```bash
az network vnet create \
  --resource-group <RESOURCE_GROUP_NAME> \
  --name datacenter-vnet \
  --location centralus \
  --address-prefixes 10.0.0.0/16 \
  --subnet-name datacenter-subnet \
  --subnet-prefixes 10.0.0.0/24
```