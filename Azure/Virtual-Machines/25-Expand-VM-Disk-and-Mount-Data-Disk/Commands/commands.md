# Commands Used

## Azure CLI Commands

```bash
# Get the lab resource group
az group list --query "[].name" --output table | grep kml

# Check the existing OS disk name
az vm show \
  -g kml_rg_main-79922f516c7843f5 \
  -n datacenter-vm \
  --query "storageProfile.osDisk.name" \
  -o tsv

# Stop the VM before resizing the OS disk
az vm stop \
  -g kml_rg_main-79922f516c7843f5 \
  -n datacenter-vm

# Resize the existing OS disk from 32 GiB to 64 GiB
az disk update \
  -g kml_rg_main-79922f516c7843f5 \
  -n datacenter-vm_disk1_363ac023aae44c419f55c165f5891cc6 \
  --size-gb 64

# Verify the OS disk size
az disk show \
  -g kml_rg_main-79922f516c7843f5 \
  -n datacenter-vm_disk1_363ac023aae44c419f55c165f5891cc6 \
  --query diskSizeGb \
  -o tsv

# Start the VM
az vm start \
  -g kml_rg_main-79922f516c7843f5 \
  -n datacenter-vm

# Create the new 64 GiB Standard HDD data disk
az disk create \
  -g kml_rg_main-79922f516c7843f5 \
  -n datacenter-disk \
  --size-gb 64 \
  --sku Standard_LRS

# Attach the data disk to the VM
az vm disk attach \
  -g kml_rg_main-79922f516c7843f5 \
  --vm-name datacenter-vm \
  --name datacenter-disk

# Get the VM public IP
az vm show \
  -g kml_rg_main-79922f516c7843f5 \
  -n datacenter-vm \
  --show-details \
  --query publicIps \
  -o tsv
```

## SSH and Disk Mount Commands

```bash
# Connect to the VM
ssh azureuser@<VM_PUBLIC_IP>

# Check available disks
lsblk

# Create an ext4 filesystem on the new disk
sudo mkfs.ext4 /dev/sdc

# Create the mount directory
sudo mkdir -p /mnt/datacenter-disk

# Mount the new data disk
sudo mount /dev/sdc /mnt/datacenter-disk

# Verify the mounted disk
df -h /mnt/datacenter-disk

# Verify disk and mount information
lsblk

# Exit the VM
exit
```

## Result

- OS disk expanded from 32 GiB to 64 GiB.
- Created `datacenter-disk` with 64 GiB Standard HDD storage.
- Attached the disk to `datacenter-vm`.
- Mounted the disk at `/mnt/datacenter-disk`.
- Verified the mount using `df -h` and `lsblk`.