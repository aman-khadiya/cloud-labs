# Azure CLI Commands

## Login to Azure

```bash
az login
```

---

## Get Resource Group

```bash
az storage account show \
  --name nautilusst2915 \
  --query resourceGroup \
  --output tsv
```

---

## Get Storage Account Key

```bash
az storage account keys list \
  --resource-group <RESOURCE_GROUP_NAME> \
  --account-name nautilusst2915 \
  --output table
```

---

## Check Current Access Level

```bash
az storage container show \
  --account-name nautilusst2915 \
  --account-key "<STORAGE_ACCOUNT_KEY>" \
  --name nautilus-container-6921 \
  --query publicAccess
```

---

## Convert Public Container to Private

```bash
az storage container set-permission \
  --account-name nautilusst2915 \
  --account-key "<STORAGE_ACCOUNT_KEY>" \
  --name nautilus-container-6921 \
  --public-access off
```

---

## Verify Access Level

```bash
az storage container show \
  --account-name nautilusst2915 \
  --account-key "<STORAGE_ACCOUNT_KEY>" \
  --name nautilus-container-6921 \
  --query publicAccess
```

---

## Verify Second Container

```bash
az storage container show \
  --account-name nautilusst2915 \
  --account-key "<STORAGE_ACCOUNT_KEY>" \
  --name nautilus-priv-3771 \
  --query publicAccess
```