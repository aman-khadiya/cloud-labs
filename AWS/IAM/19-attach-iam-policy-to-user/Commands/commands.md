# AWS CLI Commands — Attach IAM Policy to IAM User

> **Note:** This task was completed primarily using the AWS CLI. The AWS Management Console was used only to verify the attached policy and capture screenshots.

## 1. Verify the IAM User

```bash
aws iam get-user \
    --user-name iamuser_javed
```

---

## 2. Retrieve the Policy ARN

```bash
aws iam list-policies \
    --scope Local \
    --query "Policies[?PolicyName=='iampolicy_javed'].[Arn]" \
    --output text
```

---

## 3. Attach the Policy

```bash
aws iam attach-user-policy \
    --user-name iamuser_javed \
    --policy-arn arn:aws:iam::<ACCOUNT_ID>:policy/iampolicy_javed
```

Replace `<ACCOUNT_ID>` with your AWS account ID or use the ARN returned by the previous command.

---

## 4. Verify the Attached Policy

```bash
aws iam list-attached-user-policies \
    --user-name iamuser_javed
```

---

## 5. Detach the Policy (Cleanup)

```bash
aws iam detach-user-policy \
    --user-name iamuser_javed \
    --policy-arn arn:aws:iam::<ACCOUNT_ID>:policy/iampolicy_javed
```

---

## Quick Workflow

```bash
aws iam get-user --user-name iamuser_javed

aws iam list-policies \
--scope Local \
--query "Policies[?PolicyName=='iampolicy_javed'].[Arn]" \
--output text

aws iam attach-user-policy \
--user-name iamuser_javed \
--policy-arn <POLICY_ARN>

aws iam list-attached-user-policies \
--user-name iamuser_javed
```