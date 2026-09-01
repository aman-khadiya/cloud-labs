# Commands – Task 26: Create EC2 Instance with Nginx

## 1. Set AWS Region

```bash
aws configure set region us-east-1
```

---

## 2. Set AMI, VPC and Subnet IDs

```bash
AMI_ID="ami-0d7f022123f8ff19d"
VPC_ID="vpc-059e02771fbd8eb09"
SUBNET_ID="subnet-0b424752cf18e80b0"

echo $AMI_ID
echo $VPC_ID
echo $SUBNET_ID
```

---

## 3. Create Security Group

Create a Security Group named `devops-web-sg` in the selected VPC.

```bash
SG_ID=$(aws ec2 create-security-group \
  --group-name "devops-web-sg" \
  --description "Security group for Nginx web server" \
  --vpc-id "$VPC_ID" \
  --query "GroupId" \
  --output text)

echo $SG_ID
```

---

## 4. Allow HTTP Traffic on Port 80

Allow HTTP traffic from the internet.

```bash
aws ec2 authorize-security-group-ingress \
  --group-id "$SG_ID" \
  --protocol tcp \
  --port 80 \
  --cidr 0.0.0.0/0
```

---

## 5. Verify Security Group Rule

```bash
aws ec2 describe-security-groups \
  --group-ids "$SG_ID" \
  --query "SecurityGroups[0].IpPermissions" \
  --output table
```

Expected configuration:

```text
Protocol: TCP
Port: 80
Source: 0.0.0.0/0
```

---

## 6. Create User Data Script

The User Data script installs and starts Nginx automatically when the EC2 instance launches.

```bash
cat > user-data.sh <<'EOF'
#!/bin/bash
apt-get update -y
apt-get install -y nginx
systemctl start nginx
systemctl enable nginx
EOF
```

---

## 7. Launch EC2 Instance

Launch an Ubuntu EC2 instance using the selected AMI, subnet and Security Group.

```bash
INSTANCE_ID=$(aws ec2 run-instances \
  --image-id "$AMI_ID" \
  --instance-type t2.micro \
  --subnet-id "$SUBNET_ID" \
  --security-group-ids "$SG_ID" \
  --user-data file://user-data.sh \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=devops-ec2}]' \
  --query "Instances[0].InstanceId" \
  --output text)

echo $INSTANCE_ID
```

---

## 8. Verify EC2 Instance

```bash
aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --query "Reservations[0].Instances[0].[InstanceId,State.Name,InstanceType,PublicIpAddress,Placement.AvailabilityZone,Tags[?Key=='Name'].Value|[0]]" \
  --output table
```

Verify that:

- Instance state is `running`
- Instance name is `devops-ec2`
- Instance type is `t2.micro`
- A public IPv4 address is assigned
- Region is `us-east-1`

---

## 9. Verify Nginx

After the instance finishes initialization, retrieve its public IP:

```bash
PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --query "Reservations[0].Instances[0].PublicIpAddress" \
  --output text)

echo $PUBLIC_IP
```

Open the following URL in a browser:

```text
http://<PUBLIC_IP>
```

For this task, the Nginx page was accessible at:

```text
http://18.207.184.100
```

The **Welcome to nginx!** page confirms that Nginx was successfully installed and started.

---

## 10. Final Security Group Verification

```bash
aws ec2 describe-security-groups \
  --group-ids "$SG_ID" \
  --query "SecurityGroups[0].IpPermissions" \
  --output table
```

Expected result:

```text
FromPort: 80
IpProtocol: tcp
ToPort: 80
CidrIp: 0.0.0.0/0
```

---

## 11. Cleanup of Local User Data File

The local User Data script is no longer required after the instance has been launched.

```bash
rm -f user-data.sh
```

---

## Key AWS CLI Commands Used

| Command | Purpose |
|---|---|
| `aws configure` | Configure AWS CLI settings |
| `aws ec2 create-security-group` | Create Security Group |
| `aws ec2 authorize-security-group-ingress` | Allow HTTP traffic |
| `aws ec2 describe-security-groups` | Verify Security Group rules |
| `aws ec2 run-instances` | Launch EC2 instance |
| `aws ec2 describe-instances` | Verify EC2 configuration |