# Azure CLI Commands

## Login

```bash
az login
```

---

## Find Resource Group

```bash
az group list --query '[].name' --output table | grep kml
```

---

## Navigate to ARM Template Directory

```bash
cd /root/arm-templates
```

---

## Open ARM Template Using Vim

```bash
vi vnet-deployment-template.json
```

---

## Deploy ARM Template

```bash
az deployment group create \
--resource-group <RESOURCE_GROUP_NAME> \
--template-file /root/arm-templates/vnet-deployment-template.json
```

Example

```bash
az deployment group create \
--resource-group kml_rg_main-93b4fbe6496c4992 \
--template-file /root/arm-templates/vnet-deployment-template.json
```

---

## Verify Virtual Network

```bash
az network vnet list --output table
```

Or

```bash
az network vnet show \
--resource-group <RESOURCE_GROUP_NAME> \
--name arm-vnet-datacenter
```