# Azure CLI Commands

## Create Storage Account

```bash
az storage account create \
  --resource-group <RESOURCE_GROUP_NAME> \
  --name devopsst31105 \
  --location eastus \
  --sku Standard_LRS \
  --kind StorageV2
```

## Create Private Blob Container

```bash
az storage container create \
  --account-name devopsst31105 \
  --name devops-blob-13466 \
  --public-access off \
  --auth-mode login
```

## Verify Storage Account

```bash
az storage account show \
  --resource-group <RESOURCE_GROUP_NAME> \
  --name devopsst31105
```

## Verify Blob Container

```bash
az storage container list \
  --account-name devopsst31105 \
  --auth-mode login \
  --output table
```