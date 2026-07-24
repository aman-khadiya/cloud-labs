# Azure CLI Commands

This task was completed using the **Azure Portal**. The following commands provide the Azure CLI equivalent for adding and verifying the `Environment=dev` tag on the virtual machine.

## Add Tag to Virtual Machine

```bash
az vm update \
  --resource-group kml_rg_main-8d9b636c9f2e4fa7 \
  --name datacenter-vm \
  --set tags.Environment=dev
```

## Verify VM Tags

```bash
az vm show \
  --resource-group kml_rg_main-8d9b636c9f2e4fa7 \
  --name datacenter-vm \
  --query tags \
  --output table
```

## Verify Specific Environment Tag

```bash
az vm show \
  --resource-group kml_rg_main-8d9b636c9f2e4fa7 \
  --name datacenter-vm \
  --query "tags.Environment" \
  --output tsv
```

Expected output:

```text
dev
```

## Summary

- **Virtual Machine:** `datacenter-vm`
- **Tag Name:** `Environment`
- **Tag Value:** `dev`
- **Configuration:** `Environment=dev`