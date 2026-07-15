# Azure Task 44 - Azure Event Hubs Log Collection

## Objective

Integrate an existing Azure Virtual Machine with Azure Event Hubs for centralized log collection.

This task includes:

- Creating an Azure Event Hubs Namespace.
- Creating an Event Hub.
- Connecting an existing Virtual Machine.
- Executing the existing Python script multiple times.
- Verifying successful log ingestion using Azure Event Hub metrics.

---

# Services Used

- Azure Event Hubs
- Azure Virtual Machine
- Azure Portal
- Azure CLI
- Python

---

# Architecture

```
Azure VM
     │
     │ Python Script (send_logs.py)
     ▼
Azure Event Hub
     │
     ▼
Azure Event Hubs Metrics
```

---

# Prerequisites

- Azure Portal access
- Existing Azure VM
- Azure CLI
- SSH access to VM
- Existing Python script

---

# Step 1 - Create Event Hubs Namespace

Navigate to

Azure Portal

→ Event Hubs

→ Create Namespace

Configuration

- Namespace Name : xfusion-namespace
- Region : East US
- Pricing Tier : Standard
- Auto Inflate : Enabled

Create the Namespace.

---

# Step 2 - Create Event Hub

Open the created Namespace.

Create a new Event Hub.

Configuration

- Event Hub Name : xfusion-hub
- Partition Count : Default (1)
- Cleanup Policy : Delete
- Retention : Default

Create the Event Hub.

---

# Step 3 - Verify Existing VM

List the running VM.

```bash
az vm list -d -o table
```

Output showed:

- VM Name : xfusion-vm
- Status : Running
- Region : East US

---

# Step 4 - Connect to VM

SSH into the VM.

```bash
ssh azureuser@4.227.248.134
```

During the first login Azure asked to verify the host fingerprint.

Accepted by typing:

```
yes
```

SSH connection established successfully.

---

# Step 5 - Verify Existing Script

Check the available files.

```bash
ls /home/azureuser
```

Output

```
send_logs.py
```

View the script.

```bash
cat /home/azureuser/send_logs.py
```

The script already existed on the VM.

It uses Azure Event Hub Producer Client to send log messages.

---

# Step 6 - Configure Connection String

Edit the script.

```bash
nano /home/azureuser/send_logs.py
```

Replace

```python
connection_str = "<your_event_hub_connection_string>"
```

with the Event Hub connection string copied from Azure Portal.

Save the file.

---

# Step 7 - Send Logs

Execute the script multiple times.

```bash
python3 /home/azureuser/send_logs.py
python3 /home/azureuser/send_logs.py
python3 /home/azureuser/send_logs.py
```

Each execution sends multiple log events to Azure Event Hub.

---

# Step 8 - Verify Metrics

Open

Azure Portal

→ Event Hubs

→ xfusion-hub

Verify:

- Incoming Requests increased
- Successful Requests increased
- Incoming Messages increased
- Incoming Bytes increased

These metrics confirmed that log events were successfully received.

---

# Screenshots

1. Event Hub Namespace Review
2. Event Hub Namespace Created
3. Event Hub Review
4. Event Hub Created
5. VM SSH Login
6. Event Hub Metrics
7. Task Completed

---

# Commands Used

```bash
az vm list -d -o table

ssh azureuser@4.227.248.134

ls /home/azureuser

cat /home/azureuser/send_logs.py

nano /home/azureuser/send_logs.py

python3 /home/azureuser/send_logs.py
python3 /home/azureuser/send_logs.py
python3 /home/azureuser/send_logs.py

exit
```

---

# What I Learned

- How Azure Event Hubs works as a real-time event streaming platform.
- Difference between Event Hubs Namespace and Event Hub.
- How producers send events to Azure Event Hubs.
- How to connect to an Azure VM using SSH.
- How to verify an existing Python script before execution.
- How Event Hub metrics confirm successful event ingestion.
- Importance of keeping Event Hub connection strings secure.

---

# Result

Successfully created an Azure Event Hubs Namespace and Event Hub, connected to the existing Azure VM, executed the provided Python script multiple times, and verified successful log ingestion using Azure Event Hub metrics.