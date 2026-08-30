# AWS Application Load Balancer (ALB) - Commands

This document contains the AWS CLI commands used to configure and verify the Application Load Balancer, target group, security group, listener, and EC2 target.

**AWS Region:** `us-east-1`

---

## 1. Verify Existing EC2 Instance

Find the running `devops-ec2` instance and retrieve its Instance ID, VPC ID, Subnet ID, Security Group ID, and Private IP.

```bash
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=devops-ec2" \
            "Name=instance-state-name,Values=running" \
  --query "Reservations[0].Instances[0].[InstanceId,VpcId,SubnetId,SecurityGroups[0].GroupId,PrivateIpAddress]" \
  --output table
```

### Expected Information

```text
Instance ID : i-0d5c789e8f57f70a7
VPC ID      : vpc-003e214852fd5bf5d
Subnet ID   : subnet-0ff033d362c4f36c9
Private IP  : 172.31.90.61
```

---

## 2. Verify VPC Subnets

List the subnets associated with the VPC.

```bash
aws ec2 describe-subnets \
  --filters "Name=vpc-id,Values=<VPC_ID>" \
  --query "Subnets[*].[SubnetId,AvailabilityZone,MapPublicIpOnLaunch]" \
  --output table
```

Replace `<VPC_ID>` with the VPC ID obtained from the EC2 verification command.

For an internet-facing ALB, select suitable subnets in different Availability Zones.

---

## 3. Set Variables

The following variables can be used to simplify the remaining commands.

```bash
VPC_ID="vpc-003e214852fd5bf5d"
EC2_ID="i-0d5c789e8f57f70a7"
```

Set the ALB subnets according to the available public subnets in the VPC.

```bash
SUBNET_1="<PUBLIC_SUBNET_1>"
SUBNET_2="<PUBLIC_SUBNET_2>"
```

---

## 4. Create Security Group for ALB

Create the `devops-sg` security group inside the existing VPC.

```bash
aws ec2 create-security-group \
  --group-name devops-sg \
  --description "Security group for devops ALB" \
  --vpc-id "$VPC_ID"
```

The command returns the newly created Security Group ID.

Set the Security Group ID:

```bash
ALB_SG_ID="<ALB_SECURITY_GROUP_ID>"
```

---

## 5. Allow HTTP Traffic on Port 80

Allow public HTTP traffic to the ALB.

```bash
aws ec2 authorize-security-group-ingress \
  --group-id "$ALB_SG_ID" \
  --protocol tcp \
  --port 80 \
  --cidr 0.0.0.0/0
```

### Rule

```text
Protocol : TCP
Port     : 80
Source   : 0.0.0.0/0
```

---

## 6. Create Target Group

Create the `devops-tg` target group for the EC2 instance.

```bash
aws elbv2 create-target-group \
  --name devops-tg \
  --protocol HTTP \
  --port 80 \
  --vpc-id "$VPC_ID" \
  --target-type instance \
  --health-check-protocol HTTP \
  --health-check-port traffic-port \
  --health-check-path /
```

Retrieve the Target Group ARN:

```bash
TARGET_GROUP_ARN=$(aws elbv2 describe-target-groups \
  --names devops-tg \
  --query "TargetGroups[0].TargetGroupArn" \
  --output text)
```

Verify the target group:

```bash
aws elbv2 describe-target-groups \
  --names devops-tg \
  --query "TargetGroups[0].[TargetGroupName,Protocol,Port,VpcId,HealthCheckProtocol,HealthCheckPort,HealthCheckPath]" \
  --output table
```

---

## 7. Register EC2 Instance with Target Group

Register the existing `devops-ec2` instance with the target group on port `80`.

```bash
aws elbv2 register-targets \
  --target-group-arn "$TARGET_GROUP_ARN" \
  --targets Id="$EC2_ID",Port=80
```

---

## 8. Create Application Load Balancer

Create an internet-facing Application Load Balancer named `devops-alb`.

```bash
aws elbv2 create-load-balancer \
  --name devops-alb \
  --subnets "$SUBNET_1" "$SUBNET_2" \
  --security-groups "$ALB_SG_ID" \
  --scheme internet-facing \
  --type application
```

Retrieve the ALB ARN:

```bash
ALB_ARN=$(aws elbv2 describe-load-balancers \
  --names devops-alb \
  --query "LoadBalancers[0].LoadBalancerArn" \
  --output text)
```

---

## 9. Create HTTP Listener

Create an HTTP listener on port `80` and forward traffic to `devops-tg`.

```bash
aws elbv2 create-listener \
  --load-balancer-arn "$ALB_ARN" \
  --protocol HTTP \
  --port 80 \
  --default-actions Type=forward,TargetGroupArn="$TARGET_GROUP_ARN"
```

---

## 10. Verify Target Health

Check the health status of the registered EC2 target.

```bash
aws elbv2 describe-target-health \
  --target-group-arn "$TARGET_GROUP_ARN" \
  --query "TargetHealthDescriptions[*].[Target.Id,Target.Port,TargetHealth.State,TargetHealth.Reason]" \
  --output table
```

### Expected Result

```text
Target              Port    State
------------------------------------
i-0d5c789e8f57f70a7  80      healthy
```

---

## 11. Verify Load Balancer

Check the ALB state, DNS name, scheme, and type.

```bash
aws elbv2 describe-load-balancers \
  --names devops-alb \
  --query "LoadBalancers[0].[LoadBalancerName,DNSName,State.Code,Scheme,Type]" \
  --output table
```

### Expected Result

```text
Name       : devops-alb
State      : active
Scheme     : internet-facing
Type       : application
```

---

## 12. Retrieve ALB DNS Name

Retrieve only the DNS name of the ALB.

```bash
ALB_DNS=$(aws elbv2 describe-load-balancers \
  --names devops-alb \
  --query "LoadBalancers[0].DNSName" \
  --output text)

echo "$ALB_DNS"
```

Example:

```text
devops-alb-1675452715.us-east-1.elb.amazonaws.com
```

---

## 13. Verify ALB Listener

Check that the listener is configured for HTTP port `80` and forwards traffic to `devops-tg`.

```bash
aws elbv2 describe-listeners \
  --load-balancer-arn "$ALB_ARN" \
  --query "Listeners[*].[Protocol,Port,DefaultActions[0].Type,DefaultActions[0].TargetGroupArn]" \
  --output table
```

### Expected Configuration

```text
Protocol : HTTP
Port     : 80
Action   : forward
Target   : devops-tg
```

---

## 14. Test ALB HTTP Response

Test the ALB endpoint using `curl`.

```bash
curl -I "http://$ALB_DNS"
```

### Expected Response

```text
HTTP/1.1 200 OK
Content-Type: text/html
Server: nginx/1.24.0
```

A `200 OK` response confirms that traffic successfully reached the Nginx server through the ALB.

---

## 15. Verify End-to-End Traffic Flow

The complete traffic path is:

```text
Internet Client
      |
      | HTTP :80
      v
Application Load Balancer
      |
      | Listener :80
      v
Target Group: devops-tg
      |
      | HTTP :80
      v
EC2: devops-ec2
      |
      | Nginx :80
      v
Application Response
```

---

## 16. Useful Verification Commands

### Check ALB

```bash
aws elbv2 describe-load-balancers \
  --names devops-alb \
  --output table
```

### Check Target Group

```bash
aws elbv2 describe-target-groups \
  --names devops-tg \
  --output table
```

### Check Target Health

```bash
aws elbv2 describe-target-health \
  --target-group-arn "$TARGET_GROUP_ARN" \
  --output table
```

### Check Listener

```bash
aws elbv2 describe-listeners \
  --load-balancer-arn "$ALB_ARN" \
  --output table
```

### Check Security Group

```bash
aws ec2 describe-security-groups \
  --group-ids "$ALB_SG_ID" \
  --output table
```

---

## 17. Troubleshooting Commands

### Check EC2 Instance State

```bash
aws ec2 describe-instances \
  --instance-ids "$EC2_ID" \
  --query "Reservations[0].Instances[0].[InstanceId,State.Name,PrivateIpAddress]" \
  --output table
```

### Check Target Health Details

```bash
aws elbv2 describe-target-health \
  --target-group-arn "$TARGET_GROUP_ARN"
```

### Check Security Group Inbound Rules

```bash
aws ec2 describe-security-groups \
  --group-ids "$ALB_SG_ID" \
  --query "SecurityGroups[0].IpPermissions" \
  --output table
```

### Test ALB Connectivity

```bash
curl -I "http://$ALB_DNS"
```

---

## 18. Key AWS CLI Resources Used

| AWS CLI Command | Purpose |
|---|---|
| `aws ec2 describe-instances` | Verify existing EC2 instance |
| `aws ec2 describe-subnets` | Identify suitable ALB subnets |
| `aws ec2 create-security-group` | Create ALB security group |
| `aws ec2 authorize-security-group-ingress` | Allow HTTP traffic |
| `aws elbv2 create-target-group` | Create target group |
| `aws elbv2 register-targets` | Register EC2 target |
| `aws elbv2 create-load-balancer` | Create Application Load Balancer |
| `aws elbv2 create-listener` | Create HTTP listener |
| `aws elbv2 describe-target-health` | Verify target health |
| `aws elbv2 describe-load-balancers` | Verify ALB |
| `aws elbv2 describe-listeners` | Verify listener configuration |
| `curl -I` | Test HTTP response |

---

## Result

The Application Load Balancer `devops-alb` was successfully configured with:

- Public HTTP access on port `80`
- Security group `devops-sg`
- Target group `devops-tg`
- Existing EC2 instance `devops-ec2`
- HTTP listener forwarding traffic to port `80`
- Healthy EC2 target
- Successful `HTTP/1.1 200 OK` response

**Lab Status: Completed ✅**