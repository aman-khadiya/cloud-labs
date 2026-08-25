# Task 23 — Commands Reference

This document contains the Azure CLI, Linux, SSH, and verification commands used to complete Task 23.

---

## 1. Login to Azure

```bash
az login
```

---

## 2. Find the Resource Group

```bash
az group list --query "[].name" --output table | grep kml
```

Example:

```text
kml_rg_main-c206c190edca4876
```

---

## 3. Generate SSH Key Pair

Generate an RSA SSH key pair on the Azure client host:

```bash
ssh-keygen -t rsa -b 4096
```

Press **Enter** for all prompts to use the default location and no passphrase.

Generated files:

```text
/root/.ssh/id_rsa
/root/.ssh/id_rsa.pub
```

---

## 4. Verify SSH Public Key

Display the generated public key:

```bash
cat ~/.ssh/id_rsa.pub
```

---

## 5. Create Nginx Startup Script

Create the custom startup script:

```bash
cat > /tmp/nginx-setup.sh <<'EOF'
#!/bin/bash
apt-get update
apt-get install -y nginx
systemctl start nginx
systemctl enable nginx
EOF
```

Make the script executable:

```bash
chmod +x /tmp/nginx-setup.sh
```

---

## 6. Create Azure Virtual Machine

Create the VM in the East US region using the required VM size and Standard_LRS storage:

```bash
az vm create \
  --resource-group kml_rg_main-c206c190edca4876 \
  --name datacenter-vm \
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

## 7. Find the VM Network Interface

```bash
az vm show \
  --resource-group kml_rg_main-c206c190edca4876 \
  --name datacenter-vm \
  --query "networkProfile.networkInterfaces[0].id" \
  --output tsv
```

Example:

```text
/subscriptions/.../networkInterfaces/datacenter-vmVMNic
```

---

## 8. Find the Network Security Group

```bash
az network nic show \
  --resource-group kml_rg_main-c206c190edca4876 \
  --name datacenter-vmVMNic \
  --query "networkSecurityGroup.id" \
  --output tsv
```

The associated NSG is:

```text
datacenter-vmNSG
```

---

## 9. Allow HTTP Traffic on Port 80

Create an inbound NSG rule to allow HTTP traffic from the internet:

```bash
az network nsg rule create \
  --resource-group kml_rg_main-c206c190edca4876 \
  --nsg-name datacenter-vmNSG \
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

## 10. Verify NSG Rules

```bash
az network nsg rule list \
  --resource-group kml_rg_main-c206c190edca4876 \
  --nsg-name datacenter-vmNSG \
  --output table
```

Expected important rules:

```text
default-allow-ssh    Allow    Tcp    Inbound    22
Allow-HTTP           Allow    Tcp    Inbound    80
```

---

## 11. Verify the Virtual Machine

```bash
az vm show \
  --resource-group kml_rg_main-c206c190edca4876 \
  --name datacenter-vm \
  --show-details \
  --output table
```

The VM should show:

```text
Name          datacenter-vm
Location      eastus
Size          Standard_B1s
Power State   VM running
```

---

## 12. Get the VM Public IP

```bash
az vm show \
  --resource-group kml_rg_main-c206c190edca4876 \
  --name datacenter-vm \
  --show-details \
  --query publicIps \
  --output tsv
```

Example:

```text
172.172.180.37
```

---

## 13. Test HTTP Access

Replace `<PUBLIC_IP>` with the VM public IP:

```bash
curl http://<PUBLIC_IP>
```

Example:

```bash
curl http://172.172.180.37
```

A successful response should contain:

```text
Welcome to nginx!
```

---

## 14. Connect to the VM Using SSH

```bash
ssh -i ~/.ssh/id_rsa azureuser@<PUBLIC_IP>
```

Example:

```bash
ssh -i ~/.ssh/id_rsa azureuser@172.172.180.37
```

---

## 15. Verify Nginx Service

After connecting to the VM:

```bash
systemctl is-active nginx
```

Expected output:

```text
active
```

---

## 16. Check Nginx Service Status

```bash
systemctl status nginx
```

The service should show:

```text
Active: active (running)
```

---

## 17. Verify Nginx Locally

From inside the VM:

```bash
curl http://localhost
```

The response should contain:

```text
Welcome to nginx!
```

---

## 18. Exit SSH Session

```bash
exit
```

---

## 19. Final HTTP Verification

From the Azure client host:

```bash
curl http://<PUBLIC_IP>
```

Example:

```bash
curl http://172.172.180.37
```

A successful Nginx response confirms that:

- The VM is running.
- Nginx was installed using the startup script.
- Nginx is running.
- HTTP port 80 is allowed through the NSG.
- The VM is accessible from the internet.
- The VM is configured in the East US region.
- The VM uses Standard_B1s.
- The OS disk uses Standard_LRS storage.

---

## Command Summary

| Purpose | Command |
|---|---|
| Login to Azure | `az login` |
| Find resource group | `az group list` |
| Generate SSH key | `ssh-keygen -t rsa -b 4096` |
| View SSH public key | `cat ~/.ssh/id_rsa.pub` |
| Create Nginx script | `cat > /tmp/nginx-setup.sh` |
| Create VM | `az vm create` |
| Find VM NIC | `az vm show` |
| Find NSG | `az network nic show` |
| Allow HTTP | `az network nsg rule create` |
| Verify NSG | `az network nsg rule list` |
| Verify VM | `az vm show` |
| Get public IP | `az vm show --query publicIps` |
| Test HTTP | `curl http://<PUBLIC_IP>` |
| SSH into VM | `ssh -i ~/.ssh/id_rsa azureuser@<PUBLIC_IP>` |
| Verify Nginx | `systemctl is-active nginx` |
| Check Nginx status | `systemctl status nginx` |
| Exit SSH | `exit` |