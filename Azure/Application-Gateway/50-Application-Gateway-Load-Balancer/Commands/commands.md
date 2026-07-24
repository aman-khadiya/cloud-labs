# Azure Task 50 - Commands Used

# SSH Key Generation

## Generate SSH Key Pair

```bash
ssh-keygen -t rsa -b 4096
```

## Display Public Key

```bash
cat ~/.ssh/id_rsa.pub
```

---

# Connect to Virtual Machines

## Connect to VM1

```bash
ssh azureuser@<VM1_PUBLIC_IP>
```

## Connect to VM2

```bash
ssh azureuser@<VM2_PUBLIC_IP>
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

# Verify Nginx

```bash
systemctl status nginx
```

---

# Configure Website on VM1

```bash
echo "Welcome to KKE Labs:Version 1" | sudo tee /var/www/html/index.html
```

---

# Verify VM1 Webpage

```bash
cat /var/www/html/index.html

curl localhost
```

---

# Configure Website on VM2

```bash
echo "Welcome to KKE Labs:Version 2" | sudo tee /var/www/html/index.html
```

---

# Verify VM2 Webpage

```bash
cat /var/www/html/index.html

curl localhost
```

---

# Browser Verification

```text
http://<APPLICATION_GATEWAY_PUBLIC_IP>
```

Refresh the browser multiple times to verify that Azure Application Gateway distributes requests between:

- Welcome to KKE Labs:Version 1
- Welcome to KKE Labs:Version 2