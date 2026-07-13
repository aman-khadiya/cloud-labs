# Azure Application Gateway with NGINX Virtual Machine

## 📌 Project Overview

This project demonstrates how to deploy an Azure Virtual Machine running an NGINX web server and securely expose it to users through Azure Application Gateway.

The project covers the complete deployment process, including Network Security Group (NSG) creation, VM provisioning using cloud-init, backend pool configuration, routing rules, and Application Gateway deployment.

---

## Architecture

Internet
        │
        ▼
Azure Application Gateway
        │
        ▼
Backend Pool
        │
        ▼
Ubuntu Virtual Machine
        │
        ▼
NGINX Web Server

---

## Services Used

- Azure Virtual Machine
- Azure Application Gateway
- Network Security Group (NSG)
- Virtual Network (VNet)
- Public IP
- Backend Pool
- HTTP Routing Rule
- Cloud-init
- NGINX

---

## Deployment Steps

### 1. Create Network Security Group

- Created NSG
- Allowed inbound HTTP (Port 80)

Screenshot

`01-network-security-group.png`

---

### 2. Configure Cloud-init Script

Installed and started NGINX automatically during VM deployment.

```bash
#!/bin/bash

apt-get update
apt-get install nginx -y
systemctl enable nginx
systemctl start nginx
```

Screenshot

`02-nginx-startup-script.png`

---

### 3. Create Ubuntu Virtual Machine

- Ubuntu Server 24.04 LTS
- Standard B1s
- SSH Authentication

Screenshot

`03-virtual-machine-created.png`

---

### 4. Verify NGINX

Opened VM Public IP in browser.

Expected Output

```
Welcome to nginx!
```

Screenshot

`04-nginx-running-direct-vm.png`

---

### 5. Create Application Gateway

Configured

- Standard Tier
- Public Frontend
- Backend Pool
- HTTP Listener
- HTTP Routing Rule

Screenshots

```
05-application-gateway-basic.png
06-application-gateway-frontend.png
07-backend-pool.png
08-routing-rule-listener.png
09-routing-rule-backend.png
10-application-gateway-review-create.png
```

---

### 6. Verify Application Gateway

Application Gateway successfully routed traffic to the backend VM.

Screenshot

`11-application-gateway-created.png`

---

### 7. Test Application Gateway

Opened Application Gateway Public IP.

Expected Output

```
Welcome to nginx!
```

Screenshot

`12-nginx-via-application-gateway.png`

---

### 8. Task Completed

Successfully completed the Azure lab.

Screenshot

`13-task-completed.png`

---

## Outcome

Successfully deployed an Azure Application Gateway that forwards HTTP traffic to an Ubuntu Virtual Machine running NGINX.

---

## Skills Demonstrated

- Azure Virtual Machines
- Network Security Groups
- Virtual Networking
- Cloud-init
- NGINX
- Azure Application Gateway
- Backend Pools
- HTTP Routing
- Azure Infrastructure Deployment

---

## Author

Aman Khadia

Cloud & DevOps Learner