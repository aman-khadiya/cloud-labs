# AWS S3 - Enable Bucket Versioning

## Overview

This lab demonstrates how to enable versioning for an existing Amazon S3 bucket. Bucket Versioning helps protect data by preserving multiple versions of an object, making it easier to recover from accidental deletion or overwrites.

---

## Objective

Enable versioning for the following S3 bucket:

- **Bucket Name:** `xfusion-s3-13671`
- **Region:** `us-east-1`

---

## AWS Services Used

- Amazon S3

---

## Steps Performed

1. Logged in to the AWS Management Console using the provided lab credentials.
2. Switched to the **US East (N. Virginia)** (`us-east-1`) region.
3. Opened the existing S3 bucket **xfusion-s3-13671**.
4. Navigated to the **Properties** tab.
5. Edited the **Bucket Versioning** configuration.
6. Selected **Enable** and saved the changes.
7. Verified that Bucket Versioning was successfully enabled.
8. Submitted the lab and confirmed successful completion.

---

## Result

Successfully enabled **Bucket Versioning** for the S3 bucket **xfusion-s3-13671**.

---

## Key Learnings

- Bucket Versioning protects objects from accidental deletion and overwrites.
- Every new version of an object is stored independently.
- Versioning improves data recovery and backup capabilities.
- Once enabled, versioning can only be suspended—not completely disabled.

---

## Screenshots

| Screenshot | Description |
|------------|-------------|
| 01-task-details.png | KodeKloud task requirements |
| 02-versioning-settings.png | Bucket Versioning configuration page |
| 03-versioning-enabled.png | Bucket Versioning enabled successfully |
| 04-task-completed.png | KodeKloud task completed successfully |