# AWS EC2 - Create Security Group

## Overview

This lab demonstrates how to create a Security Group in the default VPC and configure inbound rules for HTTP and SSH access.

---

## Objective

Create a Security Group with the following configuration:

- **Security Group Name:** `nautilus-sg`
- **Description:** Security group for Nautilus App Servers
- **VPC:** Default VPC
- **Region:** us-east-1

### Inbound Rules

| Type | Protocol | Port | Source |
|------|----------|------|--------|
| HTTP | TCP | 80 | 0.0.0.0/0 |
| SSH | TCP | 22 | 0.0.0.0/0 |

---

## AWS Services Used

- Amazon EC2
- Amazon VPC

---

## Steps Performed

1. Logged in to the AWS Management Console.
2. Switched to the **US East (N. Virginia)** (`us-east-1`) region.
3. Opened the **EC2 Dashboard**.
4. Navigated to **Network & Security → Security Groups**.
5. Clicked **Create Security Group**.
6. Entered the following details:
   - Security Group Name: `nautilus-sg`
   - Description: `Security group for Nautilus App Servers`
   - VPC: Default VPC
7. Added the following inbound rules:
   - HTTP (TCP 80) from `0.0.0.0/0`
   - SSH (TCP 22) from `0.0.0.0/0`
8. Clicked **Create Security Group**.
9. Verified the Security Group was created successfully.
10. Submitted the lab and verified that the task completed successfully.

---

## Result

Successfully created the Security Group **nautilus-sg** in the default VPC with HTTP and SSH inbound access.

---

## Key Learnings

- Security Groups act as virtual firewalls for EC2 instances.
- HTTP uses port 80.
- SSH uses port 22.
- Inbound rules control incoming traffic to AWS resources.

---

## Screenshots

| Screenshot | Description |
|------------|-------------|
| 01-ec2-dashboard.png | EC2 Dashboard |
| 02-security-groups-page.png | Security Groups page |
| 03-create-security-group.png | Security Group configuration before creation |
| 04-security-group-created.png | Security Group created successfully |
| 05-task-complete.png | KodeKloud task completed successfully |