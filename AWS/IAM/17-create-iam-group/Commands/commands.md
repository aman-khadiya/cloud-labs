# AWS CLI Commands — Create IAM Group

> **Note:** This task was completed using the **AWS Management Console**. The following AWS CLI commands are provided as equivalent commands for future automation practice.

## 1. Create IAM Group

```bash
aws iam create-group \
    --group-name iamgroup_javed
```

---

## 2. Verify the Group

```bash
aws iam get-group \
    --group-name iamgroup_javed
```

---

## 3. List IAM Groups

```bash
aws iam list-groups
```

---

## 4. Delete the Group (Cleanup)

```bash
aws iam delete-group \
    --group-name iamgroup_javed
```

---

## Quick Workflow

```bash
aws iam create-group --group-name iamgroup_javed

aws iam get-group --group-name iamgroup_javed

aws iam list-groups
```