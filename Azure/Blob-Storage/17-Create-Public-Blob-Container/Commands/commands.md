# Azure CLI Commands

## Create Storage Account

```bash
az storage account create \
  --name nautilusst14332 \
  --resource-group <RESOURCE_GROUP_NAME> \
  --location eastus \
  --sku Standard_LRS \
  --allow-blob-public-access true
```

---

## Create Public Blob Container

```bash
az storage container create \
  --name nautilus-blob-3846 \
  --account-name nautilusst14332 \
  --public-access container \
  --auth-mode login
```

---

## Verify Storage Account

```bash
az storage account show \
  --name nautilusst14332 \
  --resource-group <RESOURCE_GROUP_NAME>
```

---

## Verify Blob Container

```bash
az storage container show \
  --name nautilus-blob-3846 \
  --account-name nautilusst14332 \
  --auth-mode login
```