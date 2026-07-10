# AWS EC2 - Create Key Pair

## Overview

This lab demonstrates how to create an RSA Key Pair in Amazon EC2. The key pair is used for secure SSH authentication when connecting to EC2 instances.

---

## Objective

Create an EC2 Key Pair with the following configuration:

- **Key Pair Name:** `nautilus-kp`
- **Key Pair Type:** RSA
- **Region:** us-east-1

---

## AWS Services Used

- Amazon EC2

---

## Steps Performed

1. Logged in to the AWS Management Console.
2. Switched to the **US East (N. Virginia)** (`us-east-1`) region.
3. Opened the **EC2 Dashboard**.
4. Navigated to **Network & Security → Key Pairs**.
5. Clicked **Create Key Pair**.
6. Entered the name **nautilus-kp**.
7. Selected **RSA** as the key pair type.
8. Created the key pair and downloaded the private key (`.pem`) file.

---

## Result

Successfully created the RSA Key Pair **nautilus-kp** in the **us-east-1** region.

---

## Key Learnings

- EC2 Key Pairs are used for SSH authentication.
- RSA is the default and widely used key pair type.
- The private key (.pem) should be stored securely because it cannot be downloaded again.

---

## Screenshots

| Screenshot | Description |
|------------|-------------|
| 01-login.png | AWS Console Login |
| 02-ec2-dashboard.png | EC2 Dashboard |
| 03-create-keypair.png | Create Key Pair Form |
| 04-keypair-created.png | Key Pair Successfully Created |