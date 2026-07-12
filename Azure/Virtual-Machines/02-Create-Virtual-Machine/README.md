# Azure Virtual Machine

## Overview

This lab demonstrates how to create an Azure Virtual Machine using the Azure Portal. The virtual machine was configured with the required specifications, secured using SSH public key authentication, and successfully accessed through SSH from the KodeKloud Azure client.

---

## Objective

Create an Azure Virtual Machine with the following requirements:

- Existing Resource Group
- VM Name: **devops-vm**
- Region: **East US**
- Image: **Ubuntu Server 24.04 LTS**
- VM Size: **Standard_B1s**
- Authentication: **SSH Public Key**
- Allow inbound **SSH (22)**
- OS Disk: **30 GB Standard HDD**
- Successfully connect to the VM using SSH

---

## Azure Services Used

- Azure Virtual Machines
- Azure Virtual Network
- Azure Network Security Group (NSG)
- Azure Managed Disk
- Azure Public IP Address

---

## Steps Performed

1. Logged in to the Azure Portal.
2. Opened the Virtual Machines service.
3. Created a new Virtual Machine using the existing Resource Group.
4. Configured the VM:
   - VM Name: **devops-vm**
   - Region: **East US**
   - Image: **Ubuntu Server 24.04 LTS**
   - VM Size: **Standard_B1s**
5. Selected **SSH Public Key** authentication.
6. Generated an RSA SSH key pair on the KodeKloud **azure-client**.
7. Copied the generated public key and pasted it into the Azure Portal.
8. Configured the OS disk as **30 GB Standard HDD**.
9. Allowed inbound SSH (Port 22) using the default Network Security Group.
10. Reviewed and created the Virtual Machine.
11. Connected to the VM successfully using SSH.
12. Verified the task completion on KodeKloud.

---

## SSH Key Generation

The RSA SSH key pair was generated on the **azure-client** because no existing Azure SSH key was available.

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
```

Display the public key:

```bash
cat ~/.ssh/id_rsa.pub
```

---

## SSH Connection

```bash
ssh azureuser@<PUBLIC_IP>
```

---

## Result

Successfully created an Azure Virtual Machine named **devops-vm** with the required specifications and connected to it securely using SSH.

---

## Screenshots

| Screenshot | Description |
|------------|-------------|
| 01-task.png | KodeKloud task requirements |
| 02-virtual-machines-page.png | Azure Virtual Machines page |
| 03-vm-basic-configuration.png | Basic VM configuration |
| 04-vm-disk-configuration.png | Disk configuration |
| 05-review-and-create.png | Review and validation |
| 06-deployment-completed.png | Successful deployment |
| 07-generate-ssh-key.png | Generate RSA SSH key on azure-client |
| 08-ssh-connected.png | Successful SSH login |
| 09-task-completed.png | KodeKloud task completed |

---

## Folder Structure

```text
02-Create-Virtual-Machine/
│
├── README.md
├── scripts/
│   └── azure-cli-commands.txt
└── screenshots/
```