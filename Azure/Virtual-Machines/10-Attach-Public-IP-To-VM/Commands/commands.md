# Azure CLI Commands

## Attach Existing Public IP Address to a Network Interface

```bash
az network nic ip-config update \
    --resource-group <RESOURCE_GROUP_NAME> \
    --nic-name <NIC_NAME> \
    --name <IP_CONFIGURATION_NAME> \
    --public-ip-address devops-pip
```

## Verify the Network Interface Configuration

```bash
az network nic show \
    --resource-group <RESOURCE_GROUP_NAME> \
    --name <NIC_NAME> \
    --output table
```

## Verify the Public IP Address

```bash
az network public-ip show \
    --resource-group <RESOURCE_GROUP_NAME> \
    --name devops-pip
```