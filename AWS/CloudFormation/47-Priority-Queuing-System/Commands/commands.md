# AWS CloudFormation - Priority Queuing System

This document contains all AWS CLI commands used to deploy, test, verify, and troubleshoot the priority queuing system.

---

# Validate CloudFormation Template

```bash
aws cloudformation validate-template \
--template-body file:///root/nautilus-priority-stack.yml
```

---

# Create CloudFormation Stack

```bash
aws cloudformation create-stack \
--stack-name nautilus-priority-stack \
--template-body file:///root/nautilus-priority-stack.yml \
--capabilities CAPABILITY_NAMED_IAM
```

---

# Wait for Stack Creation

```bash
aws cloudformation wait stack-create-complete \
--stack-name nautilus-priority-stack
```

---

# Check Stack Status

```bash
aws cloudformation describe-stacks \
--stack-name nautilus-priority-stack \
--query "Stacks[0].StackStatus"
```

---

# Update Lambda Function Code

```bash
cp /root/index.py /tmp/

cd /tmp

zip function.zip index.py

aws lambda update-function-code \
--function-name nautilus-priorities-queue-function \
--zip-file fileb://function.zip
```

---

# Get SNS Topic ARN

```bash
topicarn=$(aws sns list-topics \
--query "Topics[?contains(TopicArn, 'nautilus-Priority-Queues-Topic')].TopicArn" \
--output text)
```

---

# Publish High Priority Messages

```bash
aws sns publish \
--topic-arn $topicarn \
--message 'High Priority message 1' \
--message-attributes '{"priority":{"DataType":"String","StringValue":"high"}}'

aws sns publish \
--topic-arn $topicarn \
--message 'High Priority message 2' \
--message-attributes '{"priority":{"DataType":"String","StringValue":"high"}}'
```

---

# Publish Low Priority Messages

```bash
aws sns publish \
--topic-arn $topicarn \
--message 'Low Priority message 1' \
--message-attributes '{"priority":{"DataType":"String","StringValue":"low"}}'

aws sns publish \
--topic-arn $topicarn \
--message 'Low Priority message 2' \
--message-attributes '{"priority":{"DataType":"String","StringValue":"low"}}'
```

---

# Invoke Lambda

```bash
aws lambda invoke \
--function-name nautilus-priorities-queue-function \
response.json

cat response.json
```

---

# Verify SQS Queue Policies

```bash
aws sqs get-queue-attributes \
--queue-url $(aws sqs get-queue-url \
--queue-name nautilus-High-Priority-Queue \
--query QueueUrl \
--output text) \
--attribute-names Policy
```

```bash
aws sqs get-queue-attributes \
--queue-url $(aws sqs get-queue-url \
--queue-name nautilus-Low-Priority-Queue \
--query QueueUrl \
--output text) \
--attribute-names Policy
```

---

# Verify SNS Subscription Attributes

```bash
aws sns get-subscription-attributes \
--subscription-arn <SubscriptionARN>
```

---

# View Stack Resources

```bash
aws cloudformation describe-stack-resources \
--stack-name nautilus-priority-stack
```

---

# Cleanup (Optional)

```bash
aws cloudformation delete-stack \
--stack-name nautilus-priority-stack
```

```bash
aws cloudformation wait stack-delete-complete \
--stack-name nautilus-priority-stack
```