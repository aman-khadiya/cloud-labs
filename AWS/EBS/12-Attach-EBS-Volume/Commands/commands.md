# AWS CLI Commands

> **Note:** This task was performed using the AWS Management Console.  
> The following AWS CLI commands are provided as equivalent commands for future reference and automation.

## Set Region

```bash
export AWS_DEFAULT_REGION=us-east-1
```

## Find the EC2 Instance

```bash
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=nautilus-ec2" \
  --query "Reservations[].Instances[].{Name:Tags[?Key=='Name']|[0].Value,InstanceId:InstanceId,State:State.Name,AvailabilityZone:Placement.AvailabilityZone}" \
  --output table
```

## Find the EBS Volume

```bash
aws ec2 describe-volumes \
  --filters "Name=tag:Name,Values=nautilus-volume" \
  --query "Volumes[].{Name:Tags[?Key=='Name']|[0].Value,VolumeId:VolumeId,State:State,AvailabilityZone:AvailabilityZone,Size:Size}" \
  --output table
```

## Store Resource IDs

```bash
INSTANCE_ID=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=nautilus-ec2" \
  --query "Reservations[0].Instances[0].InstanceId" \
  --output text)

VOLUME_ID=$(aws ec2 describe-volumes \
  --filters "Name=tag:Name,Values=nautilus-volume" \
  --query "Volumes[0].VolumeId" \
  --output text)
```

## Verify Resource IDs

```bash
echo "Instance ID: $INSTANCE_ID"
echo "Volume ID: $VOLUME_ID"
```

## Attach the EBS Volume

```bash
aws ec2 attach-volume \
  --volume-id "$VOLUME_ID" \
  --instance-id "$INSTANCE_ID" \
  --device /dev/sdb
```

## Wait for Volume to Become In-Use

```bash
aws ec2 wait volume-in-use \
  --volume-ids "$VOLUME_ID"
```

## Verify Volume Attachment

```bash
aws ec2 describe-volumes \
  --volume-ids "$VOLUME_ID" \
  --query "Volumes[].{VolumeId:VolumeId,State:State,InstanceId:Attachments[0].InstanceId,Device:Attachments[0].Device,AttachmentState:Attachments[0].State}" \
  --output table
```

## Expected Result

The output should confirm:

- Volume state: `in-use`
- Instance: `nautilus-ec2`
- Device: `/dev/sdb`
- Attachment state: `attached`

## Optional Detach Command

> Do not run this command as part of the task. It is included only for future reference.

```bash
aws ec2 detach-volume \
  --volume-id "$VOLUME_ID"
```