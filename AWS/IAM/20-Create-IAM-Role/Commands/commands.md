# Commands Used

## List Existing Policy

```bash
aws iam list-policies \
    --scope Local \
    --query "Policies[?PolicyName=='iampolicy_kirsty'].[Arn]" \
    --output text
```

---

## Check Current Directory

```bash
pwd
```

---

## Create Trust Policy File

```bash
vi trust-policy.json
```

Contents:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

---

## Verify Trust Policy

```bash
cat trust-policy.json
```

---

## Create IAM Role

```bash
aws iam create-role \
    --role-name iamrole_kirsty \
    --assume-role-policy-document file://trust-policy.json
```

---

## Attach Existing Policy

```bash
aws iam attach-role-policy \
    --role-name iamrole_kirsty \
    --policy-arn arn:aws:iam::<ACCOUNT-ID>:policy/iampolicy_kirsty
```

---

## Verify Role

```bash
aws iam get-role \
    --role-name iamrole_kirsty
```

---

## Verify Attached Policy

```bash
aws iam list-attached-role-policies \
    --role-name iamrole_kirsty
```