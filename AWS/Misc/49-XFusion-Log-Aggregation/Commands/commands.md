# Commands — AWS VPC-to-S3 Log Aggregation

> **Region:** `us-east-1`
>
> Replace placeholders such as `<PUBLIC-VPC-ID>` with the actual resource ID returned by AWS.

## 1. Existing Private Environment

### Find Private EC2
```bash
aws ec2 describe-instances \
--filters "Name=tag:Name,Values=xfusion-priv-ec2" \
--query "Reservations[].Instances[].{InstanceId:InstanceId,AMI:ImageId,PrivateIP:PrivateIpAddress,Subnet:SubnetId,VPC:VpcId}" \
--output table \
--region us-east-1
```

### Find Private Route Table
```bash
aws ec2 describe-route-tables \
--filters "Name=tag:Name,Values=xfusion-priv-rt" \
--query "RouteTables[].{RouteTableId:RouteTableId,VPC:VpcId}" \
--output table \
--region us-east-1
```

### Find Private VPC
```bash
aws ec2 describe-vpcs \
--filters "Name=tag:Name,Values=xfusion-priv-vpc" \
--query "Vpcs[].{VpcId:VpcId,CIDR:CidrBlock}" \
--output table \
--region us-east-1
```

## 2. Public VPC Networking

### Create VPC
```bash
aws ec2 create-vpc \
--cidr-block 10.20.0.0/16 \
--tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=xfusion-pub-vpc}]' \
--region us-east-1
```

### Create Subnet
```bash
aws ec2 create-subnet \
--vpc-id <PUBLIC-VPC-ID> \
--cidr-block 10.20.1.0/24 \
--availability-zone us-east-1a \
--tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=xfusion-pub-subnet}]' \
--region us-east-1
```

### Create Route Table
```bash
aws ec2 create-route-table \
--vpc-id <PUBLIC-VPC-ID> \
--tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=xfusion-pub-rt}]' \
--region us-east-1
```

### Create and Attach Internet Gateway
```bash
aws ec2 create-internet-gateway \
--tag-specifications 'ResourceType=internet-gateway,Tags=[{Key=Name,Value=xfusion-pub-igw}]' \
--region us-east-1
```

```bash
aws ec2 attach-internet-gateway \
--internet-gateway-id <IGW-ID> \
--vpc-id <PUBLIC-VPC-ID> \
--region us-east-1
```

### Associate Subnet with Route Table
```bash
aws ec2 associate-route-table \
--route-table-id <PUBLIC-RT-ID> \
--subnet-id <PUBLIC-SUBNET-ID> \
--region us-east-1
```

### Add Internet Route
```bash
aws ec2 create-route \
--route-table-id <PUBLIC-RT-ID> \
--destination-cidr-block 0.0.0.0/0 \
--gateway-id <IGW-ID> \
--region us-east-1
```

### Enable Public IPv4 Assignment
```bash
aws ec2 modify-subnet-attribute \
--subnet-id <PUBLIC-SUBNET-ID> \
--map-public-ip-on-launch \
--region us-east-1
```

### Verify Route Table
```bash
aws ec2 describe-route-tables \
--route-table-ids <PUBLIC-RT-ID> \
--query "RouteTables[0].{RouteTableId:RouteTableId,Routes:Routes,Associations:Associations}" \
--output json \
--region us-east-1
```

## 3. Security Group and EC2

### Create Security Group
```bash
aws ec2 create-security-group \
--group-name xfusion-pub-sg \
--description "SSH access for xfusion public EC2" \
--vpc-id <PUBLIC-VPC-ID> \
--region us-east-1
```

### Allow SSH
```bash
aws ec2 authorize-security-group-ingress \
--group-id <SG-ID> \
--protocol tcp \
--port 22 \
--cidr 0.0.0.0/0 \
--region us-east-1
```

### Launch Public EC2
```bash
aws ec2 run-instances \
--image-id ami-0fb0b230890ccd1e6 \
--instance-type t3.micro \
--key-name xfusion-key \
--subnet-id <PUBLIC-SUBNET-ID> \
--security-group-ids <SG-ID> \
--associate-public-ip-address \
--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=xfusion-pub-ec2}]' \
--region us-east-1
```

### Verify EC2
```bash
aws ec2 describe-instances \
--instance-ids <PUBLIC-INSTANCE-ID> \
--query "Reservations[0].Instances[0].[State.Name,PrivateIpAddress,PublicIpAddress,PublicDnsName]" \
--output table \
--region us-east-1
```

## 4. S3

### Create Bucket
```bash
aws s3api create-bucket \
--bucket xfusion-s3-logs-32508 \
--region us-east-1
```

### Verify Bucket
```bash
aws s3api head-bucket \
--bucket xfusion-s3-logs-32508 \
--region us-east-1
```

## 5. IAM Role and Instance Profile

### Trust Policy
```bash
cat > trust-policy.json <<'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {"Service": "ec2.amazonaws.com"},
      "Action": "sts:AssumeRole"
    }
  ]
}

### Create Role
```bash
aws iam create-role \
--role-name xfusion-s3-role \
--assume-role-policy-document file://trust-policy.json
```

### Least-Privilege Policy Attempt
```bash
cat > s3-put-policy.json <<'POLICY'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::xfusion-s3-logs-32508/*"
    }
  ]
}
POLICY
```

```bash
aws iam put-role-policy \
--role-name xfusion-s3-role \
--policy-name xfusion-s3-put-object \
--policy-document file://s3-put-policy.json
```

> This failed because the training IAM user was not authorized for `iam:PutRolePolicy`.

### Working Lab-Compatible Policy
```bash
aws iam attach-role-policy \
--role-name xfusion-s3-role \
--policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess
```

### Verify Policy
```bash
aws iam list-attached-role-policies \
--role-name xfusion-s3-role \
--output table
```

### Instance Profile
```bash
aws iam create-instance-profile \
--instance-profile-name xfusion-s3-role
```

```bash
aws iam add-role-to-instance-profile \
--instance-profile-name xfusion-s3-role \
--role-name xfusion-s3-role
```

```bash
sleep 10
```

```bash
aws ec2 associate-iam-instance-profile \
--instance-id <PUBLIC-INSTANCE-ID> \
--iam-instance-profile Name=xfusion-s3-role \
--region us-east-1
```

### Verify Instance Profile
```bash
aws ec2 describe-iam-instance-profile-associations \
--filters Name=instance-id,Values=<PUBLIC-INSTANCE-ID> \
--query "IamInstanceProfileAssociations[].{State:State,Profile:IamInstanceProfile.Arn}" \
--output table \
--region us-east-1
```

## 6. VPC Peering

### Create Peering
```bash
aws ec2 create-vpc-peering-connection \
--vpc-id <PRIVATE-VPC-ID> \
--peer-vpc-id <PUBLIC-VPC-ID> \
--tag-specifications 'ResourceType=vpc-peering-connection,Tags=[{Key=Name,Value=xfusion-vpc-peering}]' \
--region us-east-1
```

### Accept Peering
```bash
aws ec2 accept-vpc-peering-connection \
--vpc-peering-connection-id <PCX-ID> \
--region us-east-1
```

### Verify Peering
```bash
aws ec2 describe-vpc-peering-connections \
--vpc-peering-connection-ids <PCX-ID> \
--query "VpcPeeringConnections[0].Status.Code" \
--output text \
--region us-east-1
```

Expected: `active`

## 7. Peering Routes

### Private → Public
```bash
aws ec2 create-route \
--route-table-id <PRIVATE-RT-ID> \
--destination-cidr-block 10.20.0.0/16 \
--vpc-peering-connection-id <PCX-ID> \
--region us-east-1
```

### Public → Private
```bash
aws ec2 create-route \
--route-table-id <PUBLIC-RT-ID> \
--destination-cidr-block 10.10.0.0/16 \
--vpc-peering-connection-id <PCX-ID> \
--region us-east-1
```

### Verify Routes
```bash
aws ec2 describe-route-tables \
--route-table-ids <PRIVATE-RT-ID> <PUBLIC-RT-ID> \
--query "RouteTables[].{RT:RouteTableId,Routes:Routes[].{Destination:DestinationCidrBlock,Peering:VpcPeeringConnectionId,State:State}}" \
--output json \
--region us-east-1
```

## 8. Public EC2 IAM Verification

```bash
aws --version
```

```bash
aws sts get-caller-identity
```

Expected ARN pattern:
```text
arn:aws:sts::<ACCOUNT-ID>:assumed-role/xfusion-s3-role/<INSTANCE-ID>
```

## 9. SSH Key and SCP

### Copy Key to Public EC2 from AWS Client
```bash
scp -i /root/.ssh/xfusion-key.pem \
/root/.ssh/xfusion-key.pem \
ubuntu@<PUBLIC-IP>:/home/ubuntu/
```

### Secure Key
```bash
chmod 400 ~/xfusion-key.pem
ls -l ~/xfusion-key.pem
```

### Public → Private SSH
```bash
ssh -i ~/xfusion-key.pem ubuntu@10.10.1.240
```

### Manual Private → Public SCP
```bash
scp -i ~/xfusion-key.pem \
/var/log/boots.log \
ubuntu@10.20.1.174:/home/ubuntu/boots.log
```

### Verify Received File
```bash
ls -l /home/ubuntu/boots.log
cat /home/ubuntu/boots.log
```

## 10. Private EC2 Cron

```bash
crontab -e
```

```cron
* * * * * /usr/bin/scp -i /home/ubuntu/xfusion-key.pem -o StrictHostKeyChecking=no /var/log/boots.log ubuntu@10.20.1.174:/home/ubuntu/boots.log
```

### Verify
```bash
crontab -l
sudo grep CRON /var/log/syslog | tail -10
```

## 11. Manual Public EC2 → S3 Upload

```bash
aws s3 cp /home/ubuntu/boots.log \
s3://xfusion-s3-logs-32508/xfusion-priv-vpc/boot/boots.log \
--region us-east-1
```

```bash
aws s3api head-object \
--bucket xfusion-s3-logs-32508 \
--key xfusion-priv-vpc/boot/boots.log \
--region us-east-1
```

```bash
aws s3 ls \
s3://xfusion-s3-logs-32508/xfusion-priv-vpc/boot/ \
--region us-east-1
```

## 12. Public EC2 S3 Cron

```bash
crontab -e
```

```cron
* * * * * /usr/bin/aws s3 cp /home/ubuntu/boots.log s3://xfusion-s3-logs-32508/xfusion-priv-vpc/boot/boots.log --region us-east-1 >> /home/ubuntu/s3-upload.log 2>&1
```

### Verify Cron
```bash
crontab -l
grep CRON /var/log/syslog | tail -10
cat /home/ubuntu/s3-upload.log
```

## 13. Final S3 Verification

```bash
aws s3api head-object \
--bucket xfusion-s3-logs-32508 \
--key xfusion-priv-vpc/boot/boots.log \
--region us-east-1
```

```bash
aws s3 ls \
s3://xfusion-s3-logs-32508/xfusion-priv-vpc/boot/ \
--region us-east-1
```

Expected object:
```text
boots.log
```

## 14. Final Validation

```bash
aws ec2 describe-vpc-peering-connections \
--vpc-peering-connection-ids <PCX-ID> \
--query "VpcPeeringConnections[0].Status.Code" \
--output text \
--region us-east-1
```

```bash
aws sts get-caller-identity
```

```bash
aws s3api head-object \
--bucket xfusion-s3-logs-32508 \
--key xfusion-priv-vpc/boot/boots.log \
--region us-east-1
```
