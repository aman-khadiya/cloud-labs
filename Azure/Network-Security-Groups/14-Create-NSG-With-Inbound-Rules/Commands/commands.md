# Azure CLI Commands — Create NSG with HTTP and SSH Inbound Rules

This file contains the Azure CLI equivalent commands for the task completed through the Azure Portal.

## Variables

```bash
RESOURCE_GROUP="<your-resource-group-name>"
LOCATION="eastus"
NSG_NAME="devops-nsg"
```

## Create the Network Security Group

```bash
az network nsg create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$NSG_NAME" \
  --location "$LOCATION"
```

## Create Allow-HTTP Inbound Rule

```bash
az network nsg rule create \
  --resource-group "$RESOURCE_GROUP" \
  --nsg-name "$NSG_NAME" \
  --name "Allow-HTTP" \
  --priority 100 \
  --direction Inbound \
  --access Allow \
  --protocol Tcp \
  --source-address-prefixes "0.0.0.0/0" \
  --source-port-ranges "*" \
  --destination-address-prefixes "*" \
  --destination-port-ranges 80
```

## Create Allow-SSH Inbound Rule

```bash
az network nsg rule create \
  --resource-group "$RESOURCE_GROUP" \
  --nsg-name "$NSG_NAME" \
  --name "Allow-SSH" \
  --priority 110 \
  --direction Inbound \
  --access Allow \
  --protocol Tcp \
  --source-address-prefixes "0.0.0.0/0" \
  --source-port-ranges "*" \
  --destination-address-prefixes "*" \
  --destination-port-ranges 22
```

## Verify the Network Security Group

```bash
az network nsg show \
  --resource-group "$RESOURCE_GROUP" \
  --name "$NSG_NAME" \
  --output table
```

## Verify Inbound Security Rules

```bash
az network nsg rule list \
  --resource-group "$RESOURCE_GROUP" \
  --nsg-name "$NSG_NAME" \
  --output table
```

## Verify Allow-HTTP Rule

```bash
az network nsg rule show \
  --resource-group "$RESOURCE_GROUP" \
  --nsg-name "$NSG_NAME" \
  --name "Allow-HTTP" \
  --output table
```

## Verify Allow-SSH Rule

```bash
az network nsg rule show \
  --resource-group "$RESOURCE_GROUP" \
  --nsg-name "$NSG_NAME" \
  --name "Allow-SSH" \
  --output table
```

## Expected Configuration

The NSG should contain the following custom inbound rules:

| Rule | Priority | Protocol | Source | Destination Port | Action |
|---|---:|---|---|---:|---|
| Allow-HTTP | 100 | TCP | 0.0.0.0/0 | 80 | Allow |
| Allow-SSH | 110 | TCP | 0.0.0.0/0 | 22 | Allow |

> Note: In production environments, SSH access should normally be restricted to trusted source IP addresses instead of allowing `0.0.0.0/0`.