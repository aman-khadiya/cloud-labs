**# Commands Used – Configure Azure VM with Nginx Web Server**

This file contains the complete Azure CLI command sequence used to create the \`xfusion-vm\` virtual machine, configure Nginx using custom data, allow HTTP traffic on port 80, and verify the web server.

> All operations were performed from the **azure-client** host.

> Replace \`<PUBLIC_IP>\` with the public IP address assigned to the VM.

\`\`\`bash

# ============================================================
# 1. Find the Azure Resource Group
# ============================================================

az group list --query "[].name" --output table | grep kml

# Resource Group used:
# kml_rg_main-e260115a31e147c1


# ============================================================
# 2. Set Resource Group Variable
# ============================================================

RG="kml_rg_main-e260115a31e147c1"

echo "$RG"


# ============================================================
# 3. Generate SSH Key Pair
# ============================================================

# Generate a 4096-bit RSA SSH key pair on the azure-client host

ssh-keygen -t rsa -b 4096

# Press Enter to use:
# /root/.ssh/id_rsa
#
# Leave the passphrase empty for the lab environment.


# ============================================================
# 4. Verify SSH Key Files
# ============================================================

ls -l ~/.ssh/id_rsa ~/.ssh/id_rsa.pub


# ============================================================
# 5. Display the SSH Public Key
# ============================================================

cat ~/.ssh/id_rsa.pub

# Only the public key is supplied to Azure.
# Never expose or share ~/.ssh/id_rsa.


# ============================================================
# 6. Create Nginx Startup Script
# ============================================================

cat > /tmp/nginx-setup.sh <<'EOF'
#!/bin/bash

apt-get update
apt-get install -y nginx

systemctl enable nginx
systemctl start nginx
EOF


# ============================================================
# 7. Verify the Startup Script
# ============================================================

cat /tmp/nginx-setup.sh


# ============================================================
# 8. Make the Startup Script Executable
# ============================================================

chmod +x /tmp/nginx-setup.sh


# ============================================================
# 9. Create the Azure Virtual Machine
# ============================================================

az vm create \
  --resource-group "$RG" \
  --name xfusion-vm \
  --image Ubuntu2204 \
  --size Standard_B1s \
  --location eastus \
  --admin-username azureuser \
  --ssh-key-values ~/.ssh/id_rsa.pub \
  --storage-sku Standard_LRS \
  --nsg-rule SSH \
  --custom-data /tmp/nginx-setup.sh

# VM Configuration:
# Name       : xfusion-vm
# Region     : East US
# Image      : Ubuntu 22.04
# Size       : Standard_B1s
# Storage    : Standard_LRS
# User       : azureuser
# SSH Key    : ~/.ssh/id_rsa.pub
# Script     : /tmp/nginx-setup.sh


# ============================================================
# 10. Get the VM Network Interface
# ============================================================

az vm show \
  --resource-group "$RG" \
  --name xfusion-vm \
  --query "networkProfile.networkInterfaces[0].id" \
  --output tsv


# ============================================================
# 11. Store the Network Interface Information
# ============================================================

NIC_ID=$(az vm show \
  --resource-group "$RG" \
  --name xfusion-vm \
  --query "networkProfile.networkInterfaces[0].id" \
  --output tsv)

NIC_NAME=$(basename "$NIC_ID")

echo "$NIC_NAME"

# Expected NIC:
# xfusion-vmVMNic


# ============================================================
# 12. Find the Associated Network Security Group
# ============================================================

az network nic show \
  --resource-group "$RG" \
  --name "$NIC_NAME" \
  --query "networkSecurityGroup.id" \
  --output tsv

# Associated NSG:
# xfusion-vmNSG


# ============================================================
# 13. Add HTTP Port 80 Inbound Rule
# ============================================================

az network nsg rule create \
  --resource-group "$RG" \
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


# ============================================================
# 14. Verify Network Security Group Rules
# ============================================================

az network nsg rule list \
  --resource-group "$RG" \
  --nsg-name xfusion-vmNSG \
  --output table

# Verify that Allow-HTTP allows:
# Protocol         : TCP
# Direction        : Inbound
# Access           : Allow
# Destination Port : 80


# ============================================================
# 15. Verify Virtual Machine Status
# ============================================================

az vm show \
  --resource-group "$RG" \
  --name xfusion-vm \
  --show-details \
  --output table


# ============================================================
# 16. Retrieve the VM Public IP
# ============================================================

az vm show \
  --resource-group "$RG" \
  --name xfusion-vm \
  --show-details \
  --query publicIps \
  --output tsv


# Store the Public IP in a variable

PUBLIC_IP=$(az vm show \
  --resource-group "$RG" \
  --name xfusion-vm \
  --show-details \
  --query publicIps \
  --output tsv)

echo "$PUBLIC_IP"


# ============================================================
# 17. Test Nginx Over HTTP
# ============================================================

curl http://$PUBLIC_IP

# Expected response contains:
# Welcome to nginx!


# ============================================================
# 18. Optional SSH Verification
# ============================================================

ssh -i ~/.ssh/id_rsa azureuser@$PUBLIC_IP


# Verify Nginx service from inside the VM

systemctl status nginx

systemctl is-active nginx

# Expected:
# active


# Exit the VM

exit


# ============================================================
# 19. Final VM Verification
# ============================================================

az vm show \
  --resource-group "$RG" \
  --name xfusion-vm \
  --show-details \
  --output table


# ============================================================
# 20. Final HTTP Verification
# ============================================================

curl http://$PUBLIC_IP

# Expected:
# Welcome to nginx!

\`\`\`

**## Expected Final Verification**

After completing the deployment:

\`\`\`text

VM Name: xfusion-vm
Region: East US
VM Size: Standard_B1s
OS: Ubuntu 22.04
Storage: Standard_LRS
Web Server: Nginx
HTTP Port: 80
NSG: xfusion-vmNSG

\`\`\`

A successful \`curl http://$PUBLIC_IP\` request returning the default **Welcome to nginx!** page confirms that the VM, Nginx service, and HTTP network access are working correctly.

**## Troubleshooting**

During VM creation, the following syntax was initially attempted:

\`\`\`bash

--nsg-rule SSH HTTP

\`\`\`

Azure CLI returned:

\`\`\`text

unrecognized arguments: HTTP

\`\`\`

Therefore, the VM was created with the SSH rule and the HTTP rule was added separately using \`az network nsg rule create\`.

**## Important Security Notes**

- Only the **public SSH key** should be supplied to Azure.
- The private SSH key \`~/.ssh/id_rsa\` must remain secure.
- Never commit SSH private keys to Git or GitHub.
- Only required inbound ports should be allowed through the NSG.
- Port 80 is acceptable for this lab, but production web applications should normally use HTTPS.
- The Nginx startup script was used to automate VM initialization.
- \`Standard_LRS\` was used as the required Standard HDD storage option.