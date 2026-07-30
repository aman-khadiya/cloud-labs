# AWS Lambda Deployment using CloudFormation

This document contains all AWS CLI commands used to validate, deploy, verify, test, and troubleshoot the AWS Lambda CloudFormation project.

---

# Validate CloudFormation Template

```bash
aws cloudformation validate-template \
--template-body file:///root/nautilus-lambda.yml
```

Expected Output

```text
Template validated successfully
```

---

# Create CloudFormation Stack

```bash
aws cloudformation create-stack \
--stack-name nautilus-lambda-app \
--template-body file:///root/nautilus-lambda.yml \
--capabilities CAPABILITY_NAMED_IAM
```

---

# Wait Until Stack Creation Completes

```bash
aws cloudformation wait stack-create-complete \
--stack-name nautilus-lambda-app
```

---

# Verify Stack Status

```bash
aws cloudformation describe-stacks \
--stack-name nautilus-lambda-app \
--query "Stacks[0].StackStatus"
```

Expected Output

```text
CREATE_COMPLETE
```

---

# View Stack Resources

```bash
aws cloudformation describe-stack-resources \
--stack-name nautilus-lambda-app
```

---

# Verify Lambda Function

```bash
aws lambda get-function \
--function-name nautilus-lambda
```

---

# Create Test Payload

```bash
echo '{}' > input.json
```

---

# Invoke Lambda Function

```bash
aws lambda invoke \
--function-name nautilus-lambda \
--payload file://input.json \
output.json
```

---

# View Lambda Response

```bash
cat output.json
```

Expected Output

```json
{
  "statusCode": 200,
  "body": "Welcome to KKE AWS Labs!"
}
```

---

# View CloudWatch Logs

```bash
aws logs describe-log-groups
```

---

# Describe IAM Role

```bash
aws iam get-role \
--role-name lambda_execution_role
```

---

# Delete CloudFormation Stack (Optional Cleanup)

```bash
aws cloudformation delete-stack \
--stack-name nautilus-lambda-app
```

---

# Wait for Stack Deletion

```bash
aws cloudformation wait stack-delete-complete \
--stack-name nautilus-lambda-app
```

---

# Useful Verification Commands

## List Lambda Functions

```bash
aws lambda list-functions
```

---

## List IAM Roles

```bash
aws iam list-roles
```

---

## List CloudFormation Stacks

```bash
aws cloudformation list-stacks
```

---

## List CloudWatch Log Groups

```bash
aws logs describe-log-groups
```

---

# Troubleshooting Commands

## Validate Template Again

```bash
aws cloudformation validate-template \
--template-body file:///root/nautilus-lambda.yml
```

---

## Describe Stack Events

```bash
aws cloudformation describe-stack-events \
--stack-name nautilus-lambda-app
```

---

## Get Lambda Configuration

```bash
aws lambda get-function-configuration \
--function-name nautilus-lambda
```

---

# Notes

- Region used: **us-east-1**
- Runtime: **Python 3.12**
- Memory Size: **256 MB**
- Timeout: **10 Seconds**
- IAM Role: **lambda_execution_role**
- Deployment Method: **AWS CloudFormation**