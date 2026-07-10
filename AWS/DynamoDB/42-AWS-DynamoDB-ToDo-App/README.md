# AWS DynamoDB To-Do Application

## 📌 Task Overview

This project demonstrates basic CRUD operations in Amazon DynamoDB by creating a simple To-Do application database.

### Requirements

- Create a DynamoDB table named **devops-tasks**
- Use **taskId (String)** as the Partition Key
- Insert two task records
- Verify that both records are stored with the correct status

---

## 🛠 AWS Services Used

- Amazon DynamoDB

---

## Resources Created

| Resource | Value |
|----------|-------|
| Table Name | devops-tasks |
| Partition Key | taskId (String) |
| Region | us-east-1 |

---

## Task Records

| Task ID | Description | Status |
|---------|-------------|--------|
| 1 | Learn DynamoDB | completed |
| 2 | Build To-Do App | in-progress |

---

## Verification

The inserted records were verified successfully using the DynamoDB **Explore Items** page.

Verified:

- Task ID 1 → completed
- Task ID 2 → in-progress

---

# Screenshots

## 1. Task Description

![Task Description](screenshots/01-task-description.png)

---

## 2. Create DynamoDB Table

![Create Table](screenshots/02-create-table.png)

---

## 3. Table Created Successfully

![Table Created](screenshots/03-table-created.png)

---

## 4. Inserted and Verified Items

![Items Verified](screenshots/04-items-inserted-and-verified.png)

---

## 5. Task Completed

![Completed](screenshots/05-task-completed.png)

---

## Learning Outcomes

- Created a DynamoDB table
- Understood Partition Keys
- Inserted items into DynamoDB
- Verified stored records
- Explored DynamoDB Item Explorer