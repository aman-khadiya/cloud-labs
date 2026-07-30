# AWS CLI Commands — Create IAM Policy

> **Note:** This task was completed using the **AWS Management Console**. The following AWS CLI commands provide an equivalent command-line workflow for automation practice.

## 1. Create the Policy Document

Create a file named `ec2-readonly-policy.json`:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "EC2ReadOnlyAccess",
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstances",
        "ec2:DescribeImages",
        "ec2:DescribeSnapshots"
      ],
      "Resource": "*"
    }
  ]
}
```

---

## 2. Create the IAM Policy

```bash
aws iam create-policy \
  --policy-name iampolicy_mariyam \
  --policy-document file://ec2-readonly-policy.json
```

---

## 3. Verify the Policy

```bash
aws iam list-policies \
  --scope Local
```

---

## 4. Get Policy Details

```bash
aws iam get-policy \
  --policy-arn arn:aws:iam::<ACCOUNT_ID>:policy/iampolicy_mariyam
```

Replace `<ACCOUNT_ID>` with your AWS account ID.

---

## Quick Workflow

```bash
aws iam create-policy \
  --policy-name iampolicy_mariyam \
  --policy-document file://ec2-readonly-policy.json

aws iam list-policies --scope Local
```