# Azure CLI Commands

## Login to Azure

```bash
az login
```

---

## Verify Source File

```bash
ls -l /tmp/datacenter.txt
```

---

## List Storage Accounts

```bash
az storage account list --output table
```

---

## Get Storage Account Key

```bash
az storage account keys list \
  --resource-group <RESOURCE_GROUP_NAME> \
  --account-name datacenterst19397 \
  --output table
```

---

## Upload Blob

```bash
az storage blob upload \
  --account-name datacenterst19397 \
  --account-key "<STORAGE_ACCOUNT_KEY>" \
  --container-name datacenter-blob-12017 \
  --name datacenter.txt \
  --file /tmp/datacenter.txt
```

---

## Verify Uploaded Blob

```bash
az storage blob list \
  --account-name datacenterst19397 \
  --account-key "<STORAGE_ACCOUNT_KEY>" \
  --container-name datacenter-blob-12017 \
  --output table
```