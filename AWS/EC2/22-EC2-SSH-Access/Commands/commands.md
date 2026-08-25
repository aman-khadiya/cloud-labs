# Task 22 — Commands Reference

This document contains the AWS CLI, Linux, SSH, and verification commands used to complete Task 22.

---

## 1. Verify Existing SSH Key

Check whether the required RSA public key already exists:

```bash
cat /root/.ssh/id_rsa.pub
```

---

## 2. Create SSH Directory

If `/root/.ssh/` does not exist:

```bash
mkdir -p /root/.ssh
```

Set secure directory permissions:

```bash
chmod 700 /root/.ssh
```

---

## 3. Generate RSA SSH Key

Create the required `id_rsa` key pair:

```bash
ssh-keygen -t rsa -b 4096 -f /root/.ssh/id_rsa
```

Generated files:

```text
/root/.ssh/id_rsa
/root/.ssh/id_rsa.pub
```

---

## 4. Get Public SSH Key

```bash
cat /root/.ssh/id_rsa.pub
```

The public key is used on the EC2 instance inside:

```text
/root/.ssh/authorized_keys
```

---

## 5. Find Latest Ubuntu 24.04 AMI

```bash
aws ec2 describe-images \
  --owners 099720109477 \
  --filters \
    "Name=name,Values=ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*" \
    "Name=state,Values=available" \
  --query "sort_by(Images,&CreationDate)[-1].ImageId" \
  --output text
```

Example result:

```text
ami-052355af2a014bd2c
```

---

## 6. Find Default VPC

```bash
aws ec2 describe-vpcs \
  --filters Name=is-default,Values=true \
  --query "Vpcs[0].VpcId" \
  --output text
```

---

## 7. Find Default Subnet

```bash
aws ec2 describe-subnets \
  --filters Name=default-for-az,Values=true \
  --query "Subnets[0].SubnetId" \
  --output text
```

Example:

```text
subnet-05f2f2aed57c7f542
```

---

## 8. Get aws-client Public IP

```bash
curl -s https://checkip.amazonaws.com
```

Example:

```text
65.108.255.62
```

---

## 9. Allow SSH in Security Group

Allow TCP port 22 only from the `aws-client` public IP:

```bash
aws ec2 authorize-security-group-ingress \
  --group-id sg-058d16f7880d0e2e1 \
  --protocol tcp \
  --port 22 \
  --cidr 65.108.255.62/32
```

---

## 10. Verify Security Group Rule

```bash
aws ec2 describe-security-groups \
  --group-ids sg-058d16f7880d0e2e1 \
  --query "SecurityGroups[0].IpPermissions"
```

---

## 11. Create EC2 Instance

Create the Ubuntu EC2 instance with the required name and instance type:

```bash
aws ec2 run-instances \
  --image-id ami-052355af2a014bd2c \
  --instance-type t2.micro \
  --subnet-id subnet-05f2f2aed57c7f542 \
  --security-group-ids sg-058d16f7880d0e2e1 \
  --user-data file://user-data.sh \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=nautilus-ec2}]' \
  --query "Instances[0].InstanceId" \
  --output text
```

Example result:

```text
i-07a8e4bb28751d87d
```

---

## 12. Wait for EC2 Instance

```bash
aws ec2 wait instance-running \
  --instance-ids i-07a8e4bb28751d87d
```

---

## 13. Verify EC2 Instance

```bash
aws ec2 describe-instances \
  --instance-ids i-07a8e4bb28751d87d \
  --query "Reservations[0].Instances[0].[InstanceId,InstanceType,State.Name,PublicIpAddress]" \
  --output table
```

Expected information:

```text
Instance ID    i-07a8e4bb28751d87d
Instance Type  t2.micro
State          running
Public IP      44.222.194.198
```

---

## 14. Connect Using SSH

Use the private key from the `aws-client` host:

```bash
ssh -i /root/.ssh/id_rsa root@44.222.194.198
```

---

## 15. Verify Logged-in User

After connecting to the EC2 instance:

```bash
whoami
```

Expected:

```text
root
```

---

## 16. Verify Hostname

```bash
hostname
```

Example:

```text
ip-172-31-68-220
```

---

## 17. Exit SSH Session

```bash
exit
```

---

## 18. Verify SSH Private Key Permissions

If required:

```bash
chmod 600 /root/.ssh/id_rsa
```

---

## 19. Verify SSH Directory Permissions

```bash
chmod 700 /root/.ssh
```

On the EC2 instance:

```bash
chmod 700 /root/.ssh
chmod 600 /root/.ssh/authorized_keys
```

---

## Command Summary

| Purpose | Command |
|---|---|
| Check SSH key | `cat /root/.ssh/id_rsa.pub` |
| Generate SSH key | `ssh-keygen -t rsa -b 4096 -f /root/.ssh/id_rsa` |
| Find Ubuntu AMI | `aws ec2 describe-images` |
| Find VPC | `aws ec2 describe-vpcs` |
| Find subnet | `aws ec2 describe-subnets` |
| Get public IP | `curl -s https://checkip.amazonaws.com` |
| Configure SSH access | `aws ec2 authorize-security-group-ingress` |
| Create EC2 | `aws ec2 run-instances` |
| Wait for instance | `aws ec2 wait instance-running` |
| Verify EC2 | `aws ec2 describe-instances` |
| SSH into instance | `ssh -i /root/.ssh/id_rsa root@<PUBLIC-IP>` |
| Verify user | `whoami` |
| Verify hostname | `hostname` |
| Exit SSH | `exit` |