# AWS CLI Commands

The lab task was completed using the **AWS Management Console**. The following AWS CLI commands provide an equivalent method for creating and verifying the AMI.

## 1. Find the EC2 Instance ID

Find the instance ID of the EC2 instance named `devops-ec2`:

```bash
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=devops-ec2" \
  --query "Reservations[].Instances[].InstanceId" \
  --output text \
  --region us-east-1
```

Example output:

```text
i-xxxxxxxxxxxxxxxxx
```

## 2. Create an AMI from the EC2 Instance

Replace `<INSTANCE_ID>` with the instance ID returned by the previous command:

```bash
aws ec2 create-image \
  --instance-id <INSTANCE_ID> \
  --name "devops-ec2-ami" \
  --region us-east-1
```

The command returns the ID of the newly created AMI.

Example:

```json
{
    "ImageId": "ami-xxxxxxxxxxxxxxxxx"
}
```

## 3. Wait Until the AMI Becomes Available

Replace `<AMI_ID>` with the AMI ID returned during image creation:

```bash
aws ec2 wait image-available \
  --image-ids <AMI_ID> \
  --region us-east-1
```

The command waits until AWS reports that the AMI has reached the `available` state.

## 4. Verify the AMI

```bash
aws ec2 describe-images \
  --image-ids <AMI_ID> \
  --query "Images[].{Name:Name,ImageId:ImageId,State:State}" \
  --output table \
  --region us-east-1
```

Expected state:

```text
available
```

## Console Equivalent

The same operation can be performed through:

`EC2 → Instances → Select Instance → Actions → Image and templates → Create image`

Then verify the AMI from:

`EC2 → AMIs`