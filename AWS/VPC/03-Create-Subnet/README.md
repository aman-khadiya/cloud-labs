# AWS VPC - Create Subnet

## Overview

This lab demonstrates how to create a subnet in the default Amazon VPC. A subnet is a logical subdivision of a VPC that enables you to organize AWS resources within a VPC.

---

## Objective

Create a subnet with the following configuration:

- **Subnet Name:** `devops-subnet`
- **VPC:** Default VPC
- **Region:** us-east-1

---

## AWS Services Used

- Amazon VPC

---

## Steps Performed

1. Logged in to the AWS Management Console using the provided lab credentials.
2. Switched to the **US East (N. Virginia)** (`us-east-1`) region.
3. Opened the **Amazon VPC Dashboard**.
4. Navigated to **Subnets**.
5. Clicked **Create subnet**.
6. Selected the default VPC.
7. Entered the subnet name **devops-subnet**.
8. Selected an available IPv4 subnet CIDR block.
9. Clicked **Create subnet**.
10. Verified that the subnet was created successfully.
11. Submitted the lab and confirmed successful completion.

---

## Result

Successfully created the **devops-subnet** subnet in the default VPC.

---

## Key Learnings

- A subnet is a logical subdivision of a VPC.
- Every subnet must use a unique, non-overlapping CIDR block.
- A subnet is created within a specific Availability Zone.
- AWS automatically validates overlapping CIDR blocks before creating a subnet.

---

## Screenshots

| Screenshot | Description |
|------------|-------------|
| 01-task-details.png | KodeKloud task requirements |
| 02-vpc-dashboard.png | Amazon VPC Dashboard |
| 03-subnets-page.png | Subnets page before creating the subnet |
| 04-create-subnet-page.png | Create Subnet configuration page |
| 05-subnet-created-successfully.png | Successfully created **devops-subnet** |
| 06-task-completed.png | KodeKloud task completed successfully |