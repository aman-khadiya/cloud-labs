# Azure Event Hubs - Log Collection and Blob Backup

![Azure](https://img.shields.io/badge/Cloud-Azure-blue)
![Event Hubs](https://img.shields.io/badge/Service-Event%20Hubs-orange)
![Blob Storage](https://img.shields.io/badge/Service-Blob%20Storage-blue)
![Virtual Machine](https://img.shields.io/badge/Service-Virtual%20Machine-green)

---

# Project Information

| Property | Value |
|----------|-------|
| Cloud | Microsoft Azure |
| Project | Event Hubs Log Collection & Blob Backup |
| Difficulty | Intermediate |
| Region | East US |

---

# Overview

This project demonstrates centralized log collection using Azure Event Hubs while simultaneously backing up the generated logs to Azure Blob Storage from an Azure Virtual Machine.

---

# Objective

- Create an Event Hubs Namespace.
- Create an Event Hub.
- Create a Storage Account.
- Create a Blob Container.
- Create an Azure VM.
- Copy and modify the Python script.
- Send logs to Event Hub.
- Backup logs to Blob Storage.
- Verify successful ingestion and backup.

---

# Skills Demonstrated

- Azure Event Hubs
- Azure Blob Storage
- Azure Virtual Machines
- SSH
- Python
- Azure SDK
- Blob Backup

---

# Azure Services Used

- Azure Event Hubs
- Azure Blob Storage
- Azure Virtual Machine

---

# Architecture Diagram

```text
Azure VM
     │
     │ send_logs.py
     │
     ├──────────────► Azure Event Hub
     │
     └──────────────► Azure Blob Storage
                         │
                         ▼
                     logs.txt
```

---

# Implementation Steps

1. Created Event Hubs Namespace.
2. Enabled Auto Inflate.
3. Created Event Hub.
4. Created Storage Account.
5. Created Blob Container.
6. Created Azure VM.
7. Copied Python script from client host.
8. Updated Event Hub Connection String.
9. Updated Blob Storage Connection String.
10. Installed Azure Python SDK.
11. Executed the script.
12. Verified Event Hub Metrics.
13. Verified Blob Storage backup.

---

# Commands Used

See:

```
Commands/commands.md
```

---

# Troubleshooting

### ModuleNotFoundError

Installed:

```
python3-pip
```

and Azure SDK packages.

---

# Key Learnings

- Azure Event Hub message publishing.
- Azure Blob Storage backup.
- Azure SDK installation.
- VM log forwarding.
- Event Hub metrics verification.

---

# Related Concepts

- Event Streaming
- Log Aggregation
- Blob Storage
- Python Azure SDK

---

# Screenshots

| Description |
|------------|
| Namespace Review |
| Event Hub Review |
| Storage Account Review |
| VM Review |
| Namespace Overview |
| Event Hub Created |
| Storage Account Overview |
| VM Overview |
| Script Success |
| Event Hub Metrics |
| Blob Storage Logs |
| Task Completed |

---

# Result

Successfully configured Azure Event Hubs and Azure Blob Storage for centralized log collection and backup using an Azure Virtual Machine. Logs were successfully published to Azure Event Hub and stored as `logs.txt` in Azure Blob Storage.