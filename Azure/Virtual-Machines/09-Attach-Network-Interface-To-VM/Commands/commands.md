# Azure CLI Commands

## Attach Existing Network Interface to a Virtual Machine

```bash
az vm nic add \
  --resource-group <RESOURCE_GROUP_NAME> \
  --vm-name devops-vm \
  --nics devops-nic
```

## Verify Attached Network Interfaces

```bash
az vm nic list \
  --resource-group <RESOURCE_GROUP_NAME> \
  --vm-name devops-vm \
  --output table
```