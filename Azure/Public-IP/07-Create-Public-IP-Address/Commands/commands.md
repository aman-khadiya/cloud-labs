# Commands Used

No CLI commands were used.

This task was completed using the Azure Portal.

## Azure CLI Equivalent

```bash
az network public-ip create \
  --resource-group <RESOURCE_GROUP_NAME> \
  --name xfusion-pip \
  --location eastus \
  --sku Standard \
  --allocation-method Static
```