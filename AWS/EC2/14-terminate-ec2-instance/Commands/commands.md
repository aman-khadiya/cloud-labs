# AWS CLI Commands — Terminate EC2 Instance

The original task was completed using the **AWS Management Console**.

The following AWS CLI commands provide an equivalent command-line workflow for locating, terminating, and verifying the EC2 instance.

## 1. Find the Instance by Name

```bash
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=nautilus-ec2" \
  --region us-east-1 \
  --query "Reservations[].Instances[].{InstanceID:InstanceId,Name:Tags[?Key=='Name']|[0].Value,State:State.Name}" \
  --output table
```

This command locates the EC2 instance named `nautilus-ec2` and displays its Instance ID and current state.

## 2. Store the Instance ID

```bash
INSTANCE_ID=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=nautilus-ec2" \
  --region us-east-1 \
  --query "Reservations[].Instances[].InstanceId" \
  --output text)
```

Verify the value:

```bash
echo "$INSTANCE_ID"
```

## 3. Terminate the Instance

```bash
aws ec2 terminate-instances \
  --instance-ids "$INSTANCE_ID" \
  --region us-east-1
```

The command initiates termination of the selected EC2 instance.

## 4. Wait Until the Instance Is Terminated

```bash
aws ec2 wait instance-terminated \
  --instance-ids "$INSTANCE_ID" \
  --region us-east-1
```

The AWS CLI waiter pauses until the instance reaches the `terminated` state.

## 5. Verify the Final State

```bash
aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --region us-east-1 \
  --query "Reservations[].Instances[].State.Name" \
  --output text
```

Expected output:

```text
terminated
```

## Important Note

EC2 instance termination is a destructive operation and cannot be reversed. Always verify the target Instance ID and important storage or backup requirements before terminating an instance.