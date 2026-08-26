# Azure CLI Commands - Create Azure VM with SSH Access

This document contains the complete Azure CLI, Linux, SSH, and verification commands used to complete Task 24.

---

## Login to Azure

```bash
az login
```

---

## Find the Resource Group

```bash
az group list --query "[].name" --output table | grep kml
```

Resource group used:

```text
kml_rg_main-c00278cada664c0a
```

---

## Check Existing SSH Key

Check whether an RSA SSH key already exists on the `azure-client` host:

```bash
ls -l ~/.ssh/id_rsa ~/.ssh/id_rsa.pub
```

If the key does not exist, generate a new one.

---

## Generate SSH Key Pair

Generate a 4096-bit RSA SSH key pair:

```bash
ssh-keygen -t rsa -b 4096
```

Press **Enter** for all prompts to use the default location and no passphrase.

The generated files are:

```text
/root/.ssh/id_rsa
/root/.ssh/id_rsa.pub
```

---

## Display the SSH Public Key

Display the public key that will be associated with the Azure VM:

```bash
cat ~/.ssh/id_rsa.pub
```

Only the public key should be shared with Azure. The private key must remain securely stored on the `azure-client` host.

---

## Create the Azure Virtual Machine

Create the `devops-vm` VM in the `West US` region using Ubuntu 22.04, `Standard_B1s`, `Standard_LRS`, and SSH access:

```bash
az vm create \
  --resource-group kml_rg_main-c00278cada664c0a \
  --name devops-vm \
  --image Ubuntu2204 \
  --size Standard_B1s \
  --location westus \
  --admin-username azureuser \
  --ssh-key-values ~/.ssh/id_rsa.pub \
  --storage-sku Standard_LRS \
  --nsg-rule SSH
```

Expected important values:

```text
VM Name       devops-vm
Location      westus
Image         Ubuntu 22.04
VM Size       Standard_B1s
Admin User    azureuser
Storage SKU   Standard_LRS
NSG Rule      SSH
```

---

## Verify the Virtual Machine

Check the VM configuration and current status:

```bash
az vm show \
  --resource-group kml_rg_main-c00278cada664c0a \
  --name devops-vm \
  --show-details \
  --output table
```

---

## Get the VM Public IP

Retrieve the public IP assigned to the VM:

```bash
az vm show \
  --resource-group kml_rg_main-c00278cada664c0a \
  --name devops-vm \
  --show-details \
  --query publicIps \
  --output tsv
```

The public IP assigned during this task was:

```text
52.225.53.243
```

---

## Verify Network Security Group

List the Network Security Groups associated with the resource group:

```bash
az network nsg list \
  --resource-group kml_rg_main-c00278cada664c0a \
  --output table
```

---

## Verify SSH NSG Rule

List the inbound NSG rules for the VM's Network Security Group:

```bash
az network nsg rule list \
  --resource-group kml_rg_main-c00278cada664c0a \
  --nsg-name devops-vmNSG \
  --output table
```

The SSH rule should allow inbound TCP traffic on port `22`.

---

## Test SSH Connectivity

Connect to the Azure VM using the private SSH key generated on the `azure-client` host:

```bash
ssh -i ~/.ssh/id_rsa azureuser@52.225.53.243
```

The connection should establish without asking for a password.

---

## Verify Logged-in User

After connecting to the VM:

```bash
whoami
```

Expected output:

```text
azureuser
```

---

## Verify VM Hostname

```bash
hostname
```

Expected output:

```text
devops-vm
```

---

## Exit SSH Session

```bash
exit
```

---

## Verify SSH Private Key Permissions

Ensure that the private SSH key has secure permissions:

```bash
chmod 600 ~/.ssh/id_rsa
```

---

## Verify SSH Directory Permissions

Ensure that the SSH directory has secure permissions:

```bash
chmod 700 ~/.ssh
```

---

## Verify VM Power State

```bash
az vm get-instance-view \
  --resource-group kml_rg_main-c00278cada664c0a \
  --name devops-vm \
  --query "instanceView.statuses[?starts_with(code, 'PowerState/')].displayStatus" \
  --output tsv
```

Expected:

```text
VM running
```

---

## Command Summary

| Purpose | Command |
|---|---|
| Login to Azure | `az login` |
| Find resource group | `az group list --query "[].name" --output table \| grep kml` |
| Check SSH key | `ls -l ~/.ssh/id_rsa ~/.ssh/id_rsa.pub` |
| Generate SSH key | `ssh-keygen -t rsa -b 4096` |
| Display public key | `cat ~/.ssh/id_rsa.pub` |
| Create VM | `az vm create` |
| Verify VM | `az vm show` |
| Get public IP | `az vm show --show-details --query publicIps` |
| List NSGs | `az network nsg list` |
| Verify NSG rules | `az network nsg rule list` |
| SSH into VM | `ssh -i ~/.ssh/id_rsa azureuser@<PUBLIC_IP>` |
| Verify user | `whoami` |
| Verify hostname | `hostname` |
| Exit SSH | `exit` |
| Verify VM state | `az vm get-instance-view` |

---

## Final Verification

The following commands confirmed successful passwordless SSH access:

```bash
whoami
hostname
```

Expected output:

```text
azureuser
devops-vm
```

The successful SSH connection confirms that the SSH public key from the `azure-client` host was correctly associated with the `azureuser` account on `devops-vm`.