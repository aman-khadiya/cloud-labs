# Create GP3 EBS Volume

![AWS](https://img.shields.io/badge/AWS-EC2-orange)
![Service](https://img.shields.io/badge/Storage-EBS-blue)
![Region](https://img.shields.io/badge/Region-us--east--1-green)
![Level](https://img.shields.io/badge/Lab-Beginner-success)
![Difficulty](https://img.shields.io/badge/Difficulty-Easy-brightgreen)

---

## Overview

This lab demonstrates how to create an Amazon Elastic Block Store (Amazon EBS) General Purpose SSD (gp3) volume in AWS. Amazon EBS provides persistent block storage that can be attached to Amazon EC2 instances for storing operating systems, applications, and data.

---

## Objective

Create an Amazon EBS volume with the following configuration:

- **Volume Name:** `devops-volume`
- **Volume Type:** `gp3`
- **Volume Size:** `2 GiB`
- **Region:** `us-east-1`

---

## AWS Services Used

- Amazon EC2
- Amazon Elastic Block Store (EBS)

---

## Steps Performed

1. Logged in to the AWS Management Console.
2. Switched to the **US East (N. Virginia) - us-east-1** region.
3. Opened the **EC2 Dashboard**.
4. Navigated to **Elastic Block Store → Volumes**.
5. Clicked **Create Volume**.
6. Configured the volume:
   - **Volume Type:** gp3
   - **Volume Size:** 2 GiB
   - Added the **Name** tag with the value **devops-volume**.
7. Created the EBS volume.
8. Verified that the volume status changed to **Available**.

---

## Result

Successfully created a **2 GiB General Purpose SSD (gp3) Amazon EBS volume** named **devops-volume** in the **us-east-1** region.

---

## Key Learnings

- Learned how to create an Amazon EBS volume.
- Understood the purpose of **gp3** volumes.
- Learned how to assign resource tags during creation.
- Verified the volume status after provisioning.
- Understood that EBS volumes provide persistent block storage for Amazon EC2 instances.

---

## Troubleshooting

- Ensure the correct AWS Region (**us-east-1**) is selected.
- Verify the volume type is set to **gp3**.
- Confirm the volume size is **2 GiB** before creating the volume.
- Make sure the selected Availability Zone belongs to the same region.
- Refresh the EC2 Volumes page if the newly created volume is not immediately visible.
- Verify that your IAM user has permission to create EBS volumes.

---

## Screenshots

<p align="center">
  <a href="./screenshots/01-task-overview.png">
    <img src="./screenshots/01-task-overview.png" width="45%" alt="Task Overview"/>
  </a>
  <a href="./screenshots/02-ebs-volumes-dashboard.png">
    <img src="./screenshots/02-ebs-volumes-dashboard.png" width="45%" alt="EBS Volumes Dashboard"/>
  </a>
</p>

<p align="center">
  <a href="./screenshots/03-gp3-volume-created.png">
    <img src="./screenshots/03-gp3-volume-created.png" width="45%" alt="GP3 Volume Created"/>
  </a>
  <a href="./screenshots/04-task-completed.png">
    <img src="./screenshots/04-task-completed.png" width="45%" alt="Task Completed"/>
  </a>
</p>