# Azure CLI Commands - Create Public VNet and VM

This document contains the complete Azure CLI, SSH, and verification commands used to complete Task 26.

---

## Login to Azure

Login to the Azure account:

```bash
az login
```

---

## Find the Resource Group

Find the KodeKloud lab Resource Group:

```bash
az group list --query "[].name" --output table | grep kml
```

Resource group used:

```text
kml_rg_main-c8957c3c7ca24a2a
```

---

## Create Public VNet and Subnet

Create the `nautilus-pub-vnet` VNet in the `East US` region with the `nautilus-pub-subnet` subnet:

```bash
az network vnet create \
  --resource-group kml_rg_main-c8957c3c7ca24a2a \
  --name nautilus-pub-vnet \
  --location eastus \
  --address-prefix 10.0.0.0/16 \
  --subnet-name nautilus-pub-subnet \
  --subnet-prefix 10.0.1.0/24
```

The VNet and subnet were successfully created with:

```text
VNet Name       nautilus-pub-vnet
Subnet Name     nautilus-pub-subnet
Region          East US
VNet Address    10.0.0.0/16
Subnet Address  10.0.1.0/24
```

---

## Verify VNet

Verify the created VNet:

```bash
az network vnet show \
  --resource-group kml_rg_main-c8957c3c7ca24a2a \
  --name nautilus-pub-vnet \
  --output table
```

---

## Verify Subnet

Verify the public subnet:

```bash
az network vnet subnet show \
  --resource-group kml_rg_main-c8957c3c7ca24a2a \
  --vnet-name nautilus-pub-vnet \
  --name nautilus-pub-subnet \
  --output table
```

---

## Create Public VM

Create the `nautilus-pub-vm` VM inside the `nautilus-pub-vnet` and `nautilus-pub-subnet`.

The VM uses Ubuntu 22.04, Standard B1s, Standard LRS storage, a Standard Public IP, and an NSG rule allowing SSH:

```bash
az vm create \
  --resource-group kml_rg_main-c8957c3c7ca24a2a \
  --name nautilus-pub-vm \
  --image Ubuntu2204 \
  --size Standard_B1s \
  --location eastus \
  --vnet-name nautilus-pub-vnet \
  --subnet nautilus-pub-subnet \
  --admin-username azureuser \
  --generate-ssh-keys \
  --storage-sku Standard_LRS \
  --public-ip-sku Standard \
  --nsg-rule SSH
```

Important values returned after successful VM creation:

```text
VM Name       nautilus-pub-vm
Location      eastus
Power State   VM running
Private IP    10.0.1.4
Public IP     13.82.140.22
Admin User    azureuser
```

---

## Verify Virtual Machine

Check the VM configuration and current status:

```bash
az vm show \
  --resource-group kml_rg_main-c8957c3c7ca24a2a \
  --name nautilus-pub-vm \
  --show-details \
  --output table
```

---

## Get VM Public IP

Retrieve the Public IP assigned to the VM:

```bash
az vm show \
  --resource-group kml_rg_main-c8957c3c7ca24a2a \
  --name nautilus-pub-vm \
  --show-details \
  --query publicIps \
  --output tsv
```

Public IP assigned during this task:

```text
13.82.140.22
```

---

## Verify Network Security Group

List the Network Security Groups associated with the resource group:

```bash
az network nsg list \
  --resource-group kml_rg_main-c8957c3c7ca24a2a \
  --output table
```

---

## Verify SSH Rule

The VM was created with the `--nsg-rule SSH` option, which creates an inbound rule allowing SSH traffic on TCP port `22`.

List the NSG rules:

```bash
az network nsg rule list \
  --resource-group kml_rg_main-c8957c3c7ca24a2a \
  --nsg-name nautilus-pub-vmNSG \
  --output table
```

The SSH rule should allow inbound TCP traffic on port:

```text
22
```

---

## Test SSH Connectivity

Connect to the VM using the generated SSH key:

```bash
ssh azureuser@13.82.140.22
```

The SSH connection successfully established access to the `nautilus-pub-vm` VM.

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
nautilus-pub-vm
```

---

## Exit SSH Session

```bash
exit
```

---

## Verify VM Power State

Check whether the VM is running:

```bash
az vm get-instance-view \
  --resource-group kml_rg_main-c8957c3c7ca24a2a \
  --name nautilus-pub-vm \
  --query "instanceView.statuses[?starts_with(code, 'PowerState/')].displayStatus" \
  --output tsv
```

Expected output:

```text
VM running
```

---

## Command Summary

| Purpose | Command |
|---|---|
| Login to Azure | `az login` |
| Find Resource Group | `az group list --query "[].name" --output table \| grep kml` |
| Create VNet and Subnet | `az network vnet create` |
| Verify VNet | `az network vnet show` |
| Verify Subnet | `az network vnet subnet show` |
| Create VM | `az vm create` |
| Verify VM | `az vm show` |
| Get Public IP | `az vm show --show-details --query publicIps` |
| List NSGs | `az network nsg list` |
| Verify SSH Rule | `az network nsg rule list` |
| SSH into VM | `ssh azureuser@<PUBLIC_IP>` |
| Verify User | `whoami` |
| Verify Hostname | `hostname` |
| Exit SSH | `exit` |
| Verify VM State | `az vm get-instance-view` |

---

## Final Verification

The following commands confirmed successful SSH access to the public VM:

```bash
whoami
hostname
```

Expected output:

```text
azureuser
nautilus-pub-vm
```

The successful SSH connection confirms that:

- The `nautilus-pub-vnet` VNet was created successfully.
- The `nautilus-pub-subnet` subnet was created successfully.
- The `nautilus-pub-vm` VM was deployed inside the VNet.
- The VM received a public IP address.
- SSH access on TCP port `22` was configured.
- The VM is accessible over the internet.
- The VM is running Ubuntu 22.04.