# Azure Blob Storage Cleanup

## Objective

The objective of this lab is to download the contents of an existing Azure Blob Storage container to the local Azure client host and then permanently delete the container.

---

## Prerequisites

- Azure CLI installed
- Azure Storage Account
- Access to the Azure subscription
- Storage Account Access Key

---

## Azure Services Used

- Azure Storage Account
- Azure Blob Storage
- Azure CLI

---

## Steps Performed

1. Retrieved the Storage Account access key.
2. Listed all blobs inside the private container.
3. Downloaded all blobs to the `/opt` directory.
4. Verified that the files were successfully downloaded.
5. Deleted the blob container.
6. Verified that the container no longer exists.

---

## Azure CLI Commands

See:

`scripts/azure-commands.txt`

---

## Verification

- Blob downloaded successfully to `/opt`
- Container deleted successfully
- Container existence check returned `false`

---

## Screenshots

- Task Requirements
- Blob List
- Blob Download
- Verify Download
- Delete Container
- Verify Container Deleted
- Task Completed

---

## Learning Outcomes

- Learned how to list blobs in a container.
- Downloaded blob data using Azure CLI.
- Verified downloaded files.
- Deleted a Blob Storage container.
- Verified container deletion.