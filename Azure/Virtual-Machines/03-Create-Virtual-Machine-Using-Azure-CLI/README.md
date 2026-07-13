# Create Virtual Machine Using Azure CLI

## Task Overview

Create an Azure Virtual Machine using Azure CLI without using the Azure Portal.

## Requirements

- Create a VM named `devops-vm`
- Use the `Ubuntu2204` image
- VM size: `Standard_B2s`
- Admin username: `azureuser`
- Generate SSH keys automatically
- Storage SKU: `Standard_LRS`
- OS disk size: `30 GB`
- Ensure the VM is in the `Running` state
- Verify SSH connectivity

---

## Steps Performed

### 1. Listed the existing Resource Group

```bash
az group list --output table
```

### 2. Created the Virtual Machine

```bash
az vm create \
  --resource-group <RESOURCE_GROUP_NAME> \
  --name devops-vm \
  --image Ubuntu2204 \
  --size Standard_B2s \
  --admin-username azureuser \
  --generate-ssh-keys \
  --storage-sku Standard_LRS \
  --os-disk-size-gb 30
```

### 3. Verified VM Running Status

```bash
az vm show \
  --resource-group <RESOURCE_GROUP_NAME> \
  --name devops-vm \
  --show-details \
  --query "powerState"
```

### 4. Retrieved Public IP Address

```bash
az vm list-ip-addresses \
  --resource-group <RESOURCE_GROUP_NAME> \
  --name devops-vm \
  --output table
```

### 5. Connected via SSH

```bash
ssh azureuser@<PUBLIC_IP>
```

---

## Result

The Azure Virtual Machine was successfully created using Azure CLI and verified by connecting through SSH.

---

## Screenshots

### Task Statement

![](Screenshots/01-task.png)

### Create VM using Azure CLI

![](Screenshots/02-create-vm-cli.png)

### Verify Running Status & Public IP

![](Screenshots/03-vm-status-public-ip.png)

### SSH Connection

![](Screenshots/04-ssh-connection.png)

### SSH Login Successful

![](Screenshots/05-ssh-login-success.png)

### Task Completed

![](Screenshots/06-task-completed.png)