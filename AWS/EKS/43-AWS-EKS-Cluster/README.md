# Task 43 - Create Amazon EKS Cluster

## Objective

Create an Amazon EKS cluster using a custom configuration.

## Requirements

- Create an EKS cluster named `xfusion-eks`
- Use Custom Configuration
- Use IAM Role `eksClusterRole`
- Disable EKS Auto Mode
- Use latest Kubernetes version
- Select Default VPC
- Select Availability Zones:
  - us-east-1a
  - us-east-1b
  - us-east-1c
- Configure Cluster Endpoint as Private
- Verify cluster becomes Active

---

## AWS Service Used

- Amazon EKS
- IAM
- VPC

---

## Steps Performed

1. Opened Amazon EKS Console.
2. Selected Custom Configuration.
3. Disabled EKS Auto Mode.
4. Created IAM Role `eksClusterRole`.
5. Selected latest Kubernetes version.
6. Selected Default VPC.
7. Selected three default subnets across Availability Zones.
8. Configured Cluster Endpoint Access as Private.
9. Reviewed configuration.
10. Created the EKS cluster.
11. Verified cluster status changed to Active.

---

## Verification

- Cluster Name: xfusion-eks
- IAM Role: eksClusterRole
- Endpoint Access: Private
- Kubernetes Version: Latest Stable
- Cluster Status: Active

---

## Learning Outcome

- Creating an Amazon EKS Cluster
- IAM Role for EKS
- Private Cluster Endpoint
- Default VPC Networking
- Multi-AZ High Availability