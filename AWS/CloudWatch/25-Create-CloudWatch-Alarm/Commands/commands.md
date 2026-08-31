# Commands — Task 25

## 1. Set AWS Region

```bash
export AWS_DEFAULT_REGION=us-east-1
```

---

## 2. Retrieve Ubuntu 24.04 AMI

```bash
AMI_ID=$(aws ssm get-parameter \
  --name /aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id \
  --query "Parameter.Value" \
  --output text)

echo $AMI_ID
```

---

## 3. Get Default VPC

```bash
VPC_ID=$(aws ec2 describe-vpcs \
  --filters "Name=is-default,Values=true" \
  --query "Vpcs[0].VpcId" \
  --output text)

echo $VPC_ID
```

---

## 4. Get Subnet

```bash
SUBNET_ID=$(aws ec2 describe-subnets \
  --filters "Name=vpc-id,Values=$VPC_ID" \
  --query "Subnets[0].SubnetId" \
  --output text)

echo $SUBNET_ID
```

---

## 5. Get Default Security Group

```bash
SG_ID=$(aws ec2 describe-security-groups \
  --filters "Name=vpc-id,Values=$VPC_ID" "Name=group-name,Values=default" \
  --query "SecurityGroups[0].GroupId" \
  --output text)

echo $SG_ID
```

---

## 6. Launch EC2 Instance

```bash
INSTANCE_ID=$(aws ec2 run-instances \
  --image-id "$AMI_ID" \
  --instance-type t2.micro \
  --subnet-id "$SUBNET_ID" \
  --security-group-ids "$SG_ID" \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=devops-ec2}]' \
  --query "Instances[0].InstanceId" \
  --output text)

echo $INSTANCE_ID
```

> **Note:** The first attempt returned `InsufficientInstanceCapacity` for the selected Availability Zone. Retrying the command successfully launched the instance in `us-east-1a`.

---

## 7. Verify EC2 Instance

```bash
aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --query "Reservations[0].Instances[0].[InstanceId,State.Name,InstanceType,Placement.AvailabilityZone,Tags[?Key=='Name'].Value|[0]]" \
  --output table
```

---

## 8. Get SNS Topic ARN

```bash
SNS_TOPIC_ARN=$(aws sns get-topic-attributes \
  --topic-arn "arn:aws:sns:us-east-1:$(aws sts get-caller-identity --query Account --output text):devops-sns-topic" \
  --query "Attributes.TopicArn" \
  --output text)

echo $SNS_TOPIC_ARN
```

---

## 9. Create CloudWatch Alarm

```bash
aws cloudwatch put-metric-alarm \
  --alarm-name "devops-alarm" \
  --alarm-description "Alarm when devops-ec2 CPU utilization is 90% or higher for 5 minutes" \
  --metric-name "CPUUtilization" \
  --namespace "AWS/EC2" \
  --statistic "Average" \
  --period 300 \
  --evaluation-periods 1 \
  --threshold 90 \
  --comparison-operator "GreaterThanOrEqualToThreshold" \
  --dimensions Name=InstanceId,Value="$INSTANCE_ID" \
  --alarm-actions "$SNS_TOPIC_ARN"
```

---

## 10. Verify CloudWatch Alarm

```bash
aws cloudwatch describe-alarms \
  --alarm-names "devops-alarm" \
  --query "MetricAlarms[0].[AlarmName,StateValue,MetricName,Namespace,Statistic,Period,EvaluationPeriods,Threshold,ComparisonOperator,AlarmActions]" \
  --output table
```

### Expected Configuration

```text
Alarm Name:          devops-alarm
Metric:              CPUUtilization
Namespace:           AWS/EC2
Statistic:           Average
Period:              300 seconds
Evaluation Periods:  1
Threshold:           90%
Comparison Operator: GreaterThanOrEqualToThreshold
Alarm Action:        devops-sns-topic
```

> A newly created CloudWatch alarm may initially show `INSUFFICIENT_DATA` until sufficient metric data is available.

---

## 11. Useful Verification Commands

### Verify EC2 by Name

```bash
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=devops-ec2" \
  --query "Reservations[*].Instances[*].[InstanceId,State.Name,InstanceType,Placement.AvailabilityZone]" \
  --output table
```

### Verify SNS Topic

```bash
aws sns list-topics \
  --query "Topics[?contains(TopicArn, 'devops-sns-topic')].TopicArn" \
  --output table
```

### Verify Alarm Details

```bash
aws cloudwatch describe-alarms \
  --alarm-names "devops-alarm" \
  --output table
```