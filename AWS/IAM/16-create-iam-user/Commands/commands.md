# AWS CLI Commands — Create IAM User

> **Note:** This task was completed using the AWS Management Console. The following AWS CLI commands are equivalent commands for automation practice.

## 1. Create IAM User

```bash
aws iam create-user \
    --user-name iamuser_james
```

---

## 2. Verify the User

```bash
aws iam get-user \
    --user-name iamuser_james
```

---

## 3. List IAM Users

```bash
aws iam list-users
```

---

## 4. Delete the User (Cleanup)

```bash
aws iam delete-user \
    --user-name iamuser_james
```

---

## Quick Workflow

```bash
aws iam create-user --user-name iamuser_james

aws iam get-user --user-name iamuser_james

aws iam list-users
```