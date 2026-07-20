# Commands Used

## Verify Azure Login

```bash
az account show
```

## Download Backup File

```bash
az storage blob download \
  --account-name nautilusst22162 \
  --container-name nautilus-container-8879 \
  --name nautilus-db-backup.bacpac \
  --file /opt/nautilus-db-backup.bacpac \
  --auth-mode login
```

## Verify Download

```bash
ls -lh /opt
```