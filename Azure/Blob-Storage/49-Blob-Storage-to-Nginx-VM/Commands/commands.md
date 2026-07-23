# Azure Task 49 - Commands Used

## Upload index.html to Azure Blob Storage

```bash
az storage blob upload \
  --account-name datacenterstor19515 \
  --container-name datacenter-container \
  --name index.html \
  --file /root/index.html \
  --auth-mode login
```

---

## Verify Uploaded Blob

```bash
az storage blob list \
  --account-name datacenterstor19515 \
  --container-name datacenter-container \
  --auth-mode login \
  -o table
```

---

# SSH Key Authentication

## Generate SSH Key Pair

```bash
ssh-keygen -t rsa -b 4096
```

## Display Public Key

```bash
cat ~/.ssh/id_rsa.pub
```

---

# Connect to Azure Virtual Machine

```bash
ssh azureuser@<VM_PUBLIC_IP>
```

---

# Verify Login

```bash
pwd

whoami
```

---

# Install Nginx

```bash
sudo apt update

sudo apt install nginx -y
```

---

# Enable and Start Nginx

```bash
sudo systemctl enable nginx

sudo systemctl start nginx
```

---

# Verify Nginx Service

```bash
systemctl status nginx
```

---

# Verify Default Nginx Page

```bash
curl http://localhost
```

---

# Install Azure CLI

```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

---

# Verify Azure CLI

```bash
az version
```

---

# Get Storage Account Access Keys

```bash
az storage account keys list \
  --account-name datacenterstor19515 \
  -o table
```

---

# Download index.html from Azure Blob Storage

```bash
sudo az storage blob download \
  --account-name datacenterstor19515 \
  --account-key <ACCOUNT_KEY> \
  --container-name datacenter-container \
  --name index.html \
  --file /var/www/html/index.html
```

---

# Verify Downloaded File

```bash
ls -l /var/www/html

cat /var/www/html/index.html
```

---

# Verify Website Locally

```bash
curl http://localhost
```

---

# Browser Verification

```text
http://<VM_PUBLIC_IP>
```