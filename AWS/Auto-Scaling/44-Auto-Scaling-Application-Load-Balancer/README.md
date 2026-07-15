# AWS Task 44 - Auto Scaling Group with Application Load Balancer

## Objective

Deploy a highly available web application using:

- EC2 Launch Template
- Auto Scaling Group
- Application Load Balancer
- Target Group
- Nginx
- Target Tracking Scaling Policy

---

## Services Used

- Amazon EC2
- Launch Template
- Auto Scaling Group
- Application Load Balancer (ALB)
- Target Group
- Security Groups

---

## Configuration

### Launch Template

- Name: xfusion-launch-template
- AMI: Amazon Linux
- Instance Type: t2.micro
- Security Group: xfusion-sg

### User Data

```bash
#!/bin/bash
dnf install -y nginx
systemctl enable nginx
systemctl start nginx
```

### Auto Scaling Group

- Name: xfusion-asg
- Minimum Capacity: 1
- Desired Capacity: 1
- Maximum Capacity: 2

### Scaling Policy

- Policy Type: Target Tracking
- Metric: Average CPU Utilization
- Target Value: 50%

### Target Group

- Name: xfusion-tg
- Protocol: HTTP
- Port: 80

### Application Load Balancer

- Name: xfusion-alb
- Listener: HTTP:80
- Forward To: xfusion-tg

---

## Validation

- Launch Template Created
- Auto Scaling Group Created
- Target Tracking Scaling Policy Configured (50% CPU)
- Target Group Healthy
- Application Load Balancer Active
- ALB DNS displaying Welcome to Nginx page

---

## Lessons Learned

- Target Tracking Scaling Policy must be configured with 50% CPU utilization.
- ALB Security Group must allow inbound HTTP (Port 80).
- Wait for target health checks to become Healthy before testing ALB DNS.

---

## Result

Task completed successfully.