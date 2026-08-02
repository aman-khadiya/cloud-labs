# Azure CLI Commands - Create Azure VM with Static Public IP

## Login to Azure

```bash
az login
```

---

## Find the Resource Group

```bash
az group list --query "[].name" --output table | grep kml
```

---

## Generate SSH Key Pair

```bash
ssh-keygen -t rsa -b 4096
```

Press **Enter** for all prompts to use the default location and no passphrase.

---

## Create the Virtual Machine

```bash
az vm create \
  --resource-group kml_rg_main-eb490f095ea04aad \
  --name nautilus-vm \
  --image Ubuntu2204 \
  --size Standard_B1s \
  --location centralus \
  --admin-username azureuser \
  --ssh-key-values ~/.ssh/id_rsa.pub \
  --public-ip-address nautilus-pip \
  --public-ip-address-allocation static \
  --storage-sku Standard_LRS
```

---

## Verify the Virtual Machine

```bash
az vm show \
  --resource-group kml_rg_main-eb490f095ea04aad \
  --name nautilus-vm \
  --show-details \
  --output table
```

---

## Verify the Static Public IP

```bash
az network public-ip show \
  --resource-group kml_rg_main-eb490f095ea04aad \
  --name nautilus-pip \
  --output table
```

---

## Test SSH Connectivity

Get the public IP:

```bash
az vm show \
  --resource-group kml_rg_main-eb490f095ea04aad \
  --name nautilus-vm \
  -d \
  --query publicIps \
  -o tsv
```

Connect to the VM:

```bash
ssh azureuser@<PUBLIC_IP>
```

Example:

```bash
ssh azureuser@13.86.109.3
```

Exit the VM:

```bash
exit
```