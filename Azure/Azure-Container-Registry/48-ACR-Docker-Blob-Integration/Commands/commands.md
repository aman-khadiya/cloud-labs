# Azure Task 48 - Commands Used

## Verify Azure Login

```bash
az account show
```

---

## Azure Container Registry

### Login to ACR

```bash
az acr login --name nautilusacr7556
```

---

## Docker

### Build Image

```bash
cd /root/pyapp

docker build -t nautilus/python-app:latest .
```

### Tag Image

```bash
docker tag nautilus/python-app:latest \
nautilusacr7556.azurecr.io/nautilus/python-app:latest
```

### Push Image

```bash
docker push nautilusacr7556.azurecr.io/nautilus/python-app:latest
```

---

## Azure Blob Storage

### Upload config.json

```bash
az storage blob upload \
  --account-name nautilusstor7556 \
  --container-name nautilus-config \
  --name config.json \
  --file /root/config.json \
  --auth-mode login
```

---

## Virtual Machine

### SSH

```bash
ssh azureuser@<VM_PUBLIC_IP>
```

---

## Docker Installation

```bash
sudo apt update

sudo apt install -y docker.io

sudo systemctl enable docker

sudo systemctl start docker
```

---

## Azure CLI Installation

```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

---

## Verify Installations

```bash
docker --version

az version
```

---

## Docker Permission Fix

```bash
sudo usermod -aG docker $USER

sudo systemctl restart docker
```

Reconnect:

```bash
ssh azureuser@<VM_PUBLIC_IP>
```

---

## Pull Image

```bash
docker pull \
nautilusacr7556.azurecr.io/nautilus/python-app:latest
```

---

## Run Container

```bash
docker run -d \
  --name python-app \
  -p 80:80 \
  --restart unless-stopped \
  nautilusacr7556.azurecr.io/nautilus/python-app:latest
```

---

# Troubleshooting Commands

## View Logs

```bash
docker logs python-app
```

## Download config.json

```bash
az storage blob download \
  --account-name nautilusstor7556 \
  --container-name nautilus-config \
  --name config.json \
  --file /tmp/config.json \
  --auth-mode login
```

## Recreate Container with Volume Mount

```bash
docker rm -f python-app

docker run -d \
  --name python-app \
  -p 80:80 \
  -v /tmp/config.json:/app/config.json:ro \
  --restart unless-stopped \
  nautilusacr7556.azurecr.io/nautilus/python-app:latest
```

---

## Verification

```bash
docker ps

curl http://localhost
```