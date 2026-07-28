# Azure Blob Storage - Create Private Blob Container

![Azure](https://img.shields.io/badge/Platform-Microsoft_Azure-0078D4?logo=microsoftazure&logoColor=white)
![Blob Storage](https://img.shields.io/badge/Service-Blob_Storage-blue)
![Difficulty](https://img.shields.io/badge/Difficulty-Beginner-green)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)

---

# 📖 Overview

This project demonstrates how to create an Azure Storage Account and provision a private Blob Storage container. Blob containers provide scalable object storage for unstructured data such as documents, images, backups, and application files.

A Storage Account named **devopsst31105** was created using the Standard performance tier with Locally Redundant Storage (LRS). Inside the storage account, a private Blob container named **devops-blob-13466** was created to securely store data without allowing anonymous public access.

---

# 🎯 Objective

- Create an Azure Storage Account.
- Name the storage account **devopsst31105**.
- Create a Blob container named **devops-blob-13466**.
- Configure the Blob container with **Private (No Anonymous Access)**.

---

# ☁️ Azure Services Used

- Azure Storage Account
- Azure Blob Storage

---

# 🏗️ Architecture Diagram

```text
                 Azure Subscription
                        │
                        ▼
         Storage Account (devopsst31105)
                        │
                        ▼
     Private Blob Container (devops-blob-13466)
```

---

# 📝 Steps Performed

1. Logged into the Azure Portal.
2. Opened **Storage Accounts**.
3. Created a new Storage Account named **devopsst31105**.
4. Selected Standard Performance with Locally Redundant Storage (LRS).
5. Reviewed the configuration and created the Storage Account.
6. Opened the Storage Account.
7. Navigated to **Data Storage → Containers**.
8. Created a new Blob container named **devops-blob-13466**.
9. Kept the access level as **Private (No Anonymous Access)**.
10. Verified that the container was successfully created.
11. Submitted the lab successfully.

---

# 💻 Commands Used

This task was completed using the **Azure Portal**.

Equivalent Azure CLI commands are available in **Commands/commands.md**.

---

# ⚠️ Troubleshooting

- Ensure the Storage Account name is globally unique.
- Keep the replication type as **Locally Redundant Storage (LRS)**.
- Select **Private (No Anonymous Access)** for the Blob container.
- Wait until deployment completes before creating the Blob container.

---

# 📚 Key Learnings

- Creating Azure Storage Accounts.
- Understanding Blob Storage.
- Creating private Blob containers.
- Configuring secure storage using Private access.
- Difference between Storage Account and Blob Container.

---

# 📸 Screenshots

### Task

[<img src="Screenshots/01-task.png" width="700"/>](Screenshots/01-task.png)

---

### Review and Create Storage Account

[<img src="Screenshots/02-review-create-storage-account.png" width="700"/>](Screenshots/02-review-create-storage-account.png)

---

### Create Private Blob Container

[<img src="Screenshots/03-create-private-blob-container.png" width="700"/>](Screenshots/03-create-private-blob-container.png)

---

### Container Overview

[<img src="Screenshots/04-container-overview.png" width="700"/>](Screenshots/04-container-overview.png)

---

### Task Completed

[<img src="Screenshots/05-task-completed.png" width="700"/>](Screenshots/05-task-completed.png)

---

# ✅ Result

Successfully created the Azure Storage Account **devopsst31105** and the private Blob container **devops-blob-13466**. The container was configured with Private access and the lab completed successfully.