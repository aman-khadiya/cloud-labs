# Azure CLI & Linux Commands - Expand VM Disk and Mount Data Disk

This document contains the complete Azure CLI, Linux, SSH, and verification commands used to complete Task 25.

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
kml_rg_main-79922f516c7843f5
```

---

## Check the Existing VM OS Disk

Retrieve the OS disk attached to `datacenter-vm`:

```bash
az vm show \
  --resource-group kml_rg_main-79922f516c7843f5 \
  --name datacenter-vm \
  --query "storageProfile.osDisk.name" \
  --output tsv
```

The existing OS disk was:

```text
datacenter-vm_disk1_363ac023aae44c419f55c165f5891cc6
```

---

## Stop the Virtual Machine

The VM must be stopped before resizing its OS disk:

```bash
az vm stop \
  --resource-group kml_rg_main-79922f516c7843f5 \
  --name datacenter-vm
```

---

## Resize the Existing OS Disk

Expand the existing OS disk from `32 GiB` to `64 GiB`:

```bash
az disk update \
  --resource-group kml_rg_main-79922f516c7843f5 \
  --name datacenter-vm_disk1_363ac023aae44c419f55c165f5891cc6 \
  --size-gb 64
```

The disk size was successfully updated to:

```text
64 GiB
```

---

## Verify the OS Disk Size

```bash
az disk show \
  --resource-group kml_rg_main-79922f516c7843f5 \
  --name datacenter-vm_disk1_363ac023aae44c419f55c165f5891cc6 \
  --query diskSizeGb \
  --output tsv
```

Expected:

```text
64
```

---

## Start the Virtual Machine

```bash
az vm start \
  --resource-group kml_rg_main-79922f516c7843f5 \
  --name datacenter-vm
```

---

## Create the New Data Disk

Create a new `64 GiB` Standard HDD managed disk named `datacenter-disk`:

```bash
az disk create \
  --resource-group kml_rg_main-79922f516c7843f5 \
  --name datacenter-disk \
  --size-gb 64 \
  --sku Standard_LRS
```

Important configuration:

```text
Disk Name     datacenter-disk
Disk Size     64 GiB
Disk Type     Standard HDD
SKU           Standard_LRS
```

---

## Attach the Data Disk to the VM

Attach `datacenter-disk` to `datacenter-vm`:

```bash
az vm disk attach \
  --resource-group kml_rg_main-79922f516c7843f5 \
  --vm-name datacenter-vm \
  --name datacenter-disk
```

---

## Get the VM Public IP

Retrieve the public IP address of `datacenter-vm`:

```bash
az vm show \
  --resource-group kml_rg_main-79922f516c7843f5 \
  --name datacenter-vm \
  --show-details \
  --query publicIps \
  --output tsv
```

The public IP used during this task was:

```text
20.124.179.214
```

---

## Connect to the VM Using SSH

```bash
ssh azureuser@20.124.179.214
```

Accept the host fingerprint when prompted.

---

## Check Available Disks

After connecting to the VM, check the available block devices:

```bash
lsblk
```

The new `64 GiB` disk was detected as:

```text
sdc    64G    disk
```

---

## Create a Filesystem on the New Disk

Create an `ext4` filesystem on the new disk:

```bash
sudo mkfs.ext4 /dev/sdc
```

This prepares the disk for mounting and use by the Linux operating system.

---

## Create the Mount Directory

Create the required mount point:

```bash
sudo mkdir -p /mnt/datacenter-disk
```

---

## Mount the Data Disk

Mount `/dev/sdc` at `/mnt/datacenter-disk`:

```bash
sudo mount /dev/sdc /mnt/datacenter-disk
```

---

## Verify the Mounted Disk

Check the disk usage and mount point:

```bash
df -h /mnt/datacenter-disk
```

Expected mount point:

```text
/mnt/datacenter-disk
```

The disk was successfully mounted with approximately `63 GiB` usable filesystem capacity.

---

## Verify Disk Using lsblk

```bash
lsblk
```

The final disk layout showed:

```text
sda       64G  disk
└─sda1   63.9G  part  /

sdb        4G  disk
└─sdb1     4G  part  /mnt

sdc       64G  disk  /mnt/datacenter-disk
```

This confirms that:

- The OS disk is `64 GiB`.
- The new data disk is `64 GiB`.
- The new disk is mounted at `/mnt/datacenter-disk`.

---

## Verify Logged-in User

```bash
whoami
```

Expected:

```text
azureuser
```

---

## Verify VM Hostname

```bash
hostname
```

Expected:

```text
datacenter-vm
```

---

## Exit SSH Session

```bash
exit
```

---

## Verify VM Power State

```bash
az vm get-instance-view \
  --resource-group kml_rg_main-79922f516c7843f5 \
  --name datacenter-vm \
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
| Get OS disk name | `az vm show --query "storageProfile.osDisk.name"` |
| Stop VM | `az vm stop` |
| Resize OS disk | `az disk update --size-gb 64` |
| Verify disk size | `az disk show --query diskSizeGb` |
| Start VM | `az vm start` |
| Create data disk | `az disk create --size-gb 64 --sku Standard_LRS` |
| Attach data disk | `az vm disk attach` |
| Get VM public IP | `az vm show --show-details --query publicIps` |
| SSH into VM | `ssh azureuser@<PUBLIC_IP>` |
| Check disks | `lsblk` |
| Create filesystem | `sudo mkfs.ext4 /dev/sdc` |
| Create mount directory | `sudo mkdir -p /mnt/datacenter-disk` |
| Mount data disk | `sudo mount /dev/sdc /mnt/datacenter-disk` |
| Verify mount | `df -h /mnt/datacenter-disk` |
| Verify user | `whoami` |
| Verify hostname | `hostname` |
| Exit SSH | `exit` |
| Verify VM state | `az vm get-instance-view` |

---

## Final Verification

The following commands confirmed that the task was completed successfully:

```bash
lsblk
df -h /mnt/datacenter-disk
```

Final configuration:

```text
VM              datacenter-vm
OS Disk         64 GiB
Data Disk       datacenter-disk
Data Disk Size  64 GiB
Disk Type       Standard HDD
Mount Point     /mnt/datacenter-disk
Filesystem      ext4
```

The successful `lsblk` and `df -h` output confirmed that the existing VM OS disk was expanded to `64 GiB` and the new `64 GiB` Standard HDD data disk was successfully mounted at `/mnt/datacenter-disk`.