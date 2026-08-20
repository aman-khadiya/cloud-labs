# Azure CLI Commands - Create Azure VM with Nginx Web Server

This file contains the complete Azure CLI commands used to create the `xfusion-vm` virtual machine, configure Nginx using custom data, allow HTTP traffic on port 80, and verify the web server.

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

---

## Generate SSH Key Pair

```bash
ssh-keygen -t rsa -b 4096
```

Press **Enter** for all prompts to use the default location and no passphrase.

---

## Verify SSH Key Files

```bash
ls -l ~/.ssh/id_rsa ~/.ssh/id_rsa.pub
```

---

## Display SSH Public Key

```bash
cat ~/.ssh/id_rsa.pub
```

---

## Create Nginx Startup Script

```bash
cat > /tmp/nginx-setup.sh <<'EOF'
#!/bin/bash

apt-get update
apt-get install -y nginx

systemctl enable nginx
systemctl start nginx
EOF
```

---

## Verify Startup Script

```bash
cat /tmp/nginx-setup.sh
```

---

## Make Startup Script Executable

```bash
chmod +x /tmp/nginx-setup.sh
```

---

## Create the Virtual Machine

```bash
az vm create \
  --resource-group kml_rg_main-e260115a31e147c1 \
  --name xfusion-vm \
  --image Ubuntu2204 \
  --size Standard_B1s \
  --location eastus \
  --admin-username azureuser \
  --ssh-key-values ~/.ssh/id_rsa.pub \
  --storage-sku Standard_LRS \
  --nsg-rule SSH \
  --custom-data /tmp/nginx-setup.sh
```

---

## Verify the Virtual Machine

```bash
az vm show \
  --resource-group kml_rg_main-e260115a31e147c1 \
  --name xfusion-vm \
  --show-details \
  --output table
```

---

## Get the Network Interface

```bash
az vm show \
  --resource-group kml_rg_main-e260115a31e147c1 \
  --name xfusion-vm \
  --query "networkProfile.networkInterfaces[0].id" \
  --output tsv
```

---

## Find the Network Security Group

```bash
az network nic show \
  --resource-group kml_rg_main-e260115a31e147c1 \
  --name xfusion-vmVMNic \
  --query "networkSecurityGroup.id" \
  --output tsv
```

The associated Network Security Group is:

```text
xfusion-vmNSG
```

---

## Add HTTP Port 80 Inbound Rule

```bash
az network nsg rule create \
  --resource-group kml_rg_main-e260115a31e147c1 \
  --nsg-name xfusion-vmNSG \
  --name Allow-HTTP \
  --priority 1010 \
  --direction Inbound \
  --access Allow \
  --protocol Tcp \
  --source-address-prefixes Internet \
  --source-port-ranges "*" \
  --destination-address-prefixes "*" \
  --destination-port-ranges 80
```

---

## Verify Network Security Group Rules

```bash
az network nsg rule list \
  --resource-group kml_rg_main-e260115a31e147c1 \
  --nsg-name xfusion-vmNSG \
  --output table
```

---

## Get the VM Public IP

```bash
az vm show \
  --resource-group kml_rg_main-e260115a31e147c1 \
  --name xfusion-vm \
  --show-details \
  --query publicIps \
  --output tsv
```

---

## Test Nginx HTTP Connectivity

```bash
curl http://<PUBLIC_IP>
```

Example:

```bash
curl http://13.86.109.3
```

A successful response should contain:

```text
Welcome to nginx!
```

---

## Test SSH Connectivity

```bash
ssh -i ~/.ssh/id_rsa azureuser@<PUBLIC_IP>
```

---

## Verify Nginx Service

```bash
systemctl status nginx
```

Or:

```bash
systemctl is-active nginx
```

Expected output:

```text
active
```

---

## Exit the VM

```bash
exit
```

---

## Final HTTP Verification

```bash
curl http://<PUBLIC_IP>
```

Expected response:

```text
Welcome to nginx!
```