# Azure CLI Commands — Create Managed Disk

This task was completed using the **Microsoft Azure Portal**.

The following Azure CLI commands provide the equivalent workflow for creating and verifying the managed disk.

## Variables

```bash
RESOURCE_GROUP="<resource-group-name>"
LOCATION="eastus"
DISK_NAME="datacenter-disk"
DISK_SIZE="2"
```

> Replace `<resource-group-name>` with the resource group provided by the lab environment.

## Create the Managed Disk

```bash
az disk create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$DISK_NAME" \
  --location "$LOCATION" \
  --size-gb "$DISK_SIZE" \
  --sku Standard_LRS
```

## Verify the Managed Disk

```bash
az disk show \
  --resource-group "$RESOURCE_GROUP" \
  --name "$DISK_NAME" \
  --output table
```

## Verify Important Properties

```bash
az disk show \
  --resource-group "$RESOURCE_GROUP" \
  --name "$DISK_NAME" \
  --query "{Name:name,Location:location,SizeGB:diskSizeGb,SKU:sku.name,DiskState:diskState}" \
  --output table
```

## List Managed Disks in the Resource Group

```bash
az disk list \
  --resource-group "$RESOURCE_GROUP" \
  --output table
```

## Expected Configuration

```text
Name:       datacenter-disk
Size:       2 GiB
SKU:        Standard_LRS
Disk State: Unattached
```