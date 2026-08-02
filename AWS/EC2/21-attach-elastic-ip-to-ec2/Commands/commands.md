# AWS CLI Commands

## 1. Get Latest Ubuntu AMI

```bash
aws ec2 describe-images \
    --owners 099720109477 \
    --filters "Name=name,Values=ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*" \
              "Name=state,Values=available" \
    --query "sort_by(Images,&CreationDate)[-1].ImageId" \
    --output text
```

---

## 2. Get Default Security Group

```bash
aws ec2 describe-security-groups \
    --filters Name=group-name,Values=default \
    --query "SecurityGroups[0].GroupId" \
    --output text
```

---

## 3. Get Default Subnet

```bash
aws ec2 describe-subnets \
    --filters Name=default-for-az,Values=true \
    --query "Subnets[0].SubnetId" \
    --output text
```

---

## 4. Launch EC2 Instance

```bash
aws ec2 run-instances \
    --image-id ami-xxxxxxxxxxxxxxxxx \
    --instance-type t2.micro \
    --security-group-ids sg-xxxxxxxx \
    --subnet-id subnet-xxxxxxxx \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=datacenter-ec2}]'
```

---

## 5. Wait Until Running

```bash
aws ec2 wait instance-running \
    --instance-ids <INSTANCE_ID>
```

---

## 6. Allocate Elastic IP

```bash
aws ec2 allocate-address \
    --domain vpc
```

---

## 7. Tag Elastic IP

```bash
aws ec2 create-tags \
    --resources <ALLOCATION_ID> \
    --tags Key=Name,Value=datacenter-eip
```

---

## 8. Associate Elastic IP

```bash
aws ec2 associate-address \
    --instance-id <INSTANCE_ID> \
    --allocation-id <ALLOCATION_ID>
```

---

## 9. Verify Elastic IP

```bash
aws ec2 describe-addresses
```