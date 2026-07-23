# Azure CLI Commands

## Resize an Existing Virtual Machine

```bash
az vm resize \
    --resource-group <RESOURCE_GROUP_NAME> \
    --name xfusion-vm \
    --size Standard_B2s
```

## Start the Virtual Machine

```bash
az vm start \
    --resource-group <RESOURCE_GROUP_NAME> \
    --name xfusion-vm
```

## Verify the VM Size

```bash
az vm show \
    --resource-group <RESOURCE_GROUP_NAME> \
    --name xfusion-vm \
    --query "hardwareProfile.vmSize"
```

## Verify the VM Power State

```bash
az vm get-instance-view \
    --resource-group <RESOURCE_GROUP_NAME> \
    --name xfusion-vm \
    --query "instanceView.statuses[?starts_with(code,'PowerState/')].displayStatus"
```