# AWS CLI Commands — Create EBS Snapshot

> **Note:** The lab task was completed using the AWS Management Console.  
> The following AWS CLI commands are provided as equivalent commands for future reference and automation practice.

## Region

All commands are intended for:

```bash
us-east-1
```

## 1. Find the Existing EBS Volume

Find the volume with the `Name` tag `nautilus-vol`:

```bash
aws ec2 describe-volumes \
  --filters "Name=tag:Name,Values=nautilus-vol" \
  --region us-east-1 \
  --query "Volumes[*].[VolumeId,State,Size,AvailabilityZone]" \
  --output table
```

Save the required Volume ID:

```bash
VOLUME_ID=$(aws ec2 describe-volumes \
  --filters "Name=tag:Name,Values=nautilus-vol" \
  --region us-east-1 \
  --query "Volumes[0].VolumeId" \
  --output text)
```

Verify the value:

```bash
echo $VOLUME_ID
```

## 2. Create the Snapshot

Create a snapshot with the required description and `Name` tag:

```bash
SNAPSHOT_ID=$(aws ec2 create-snapshot \
  --volume-id "$VOLUME_ID" \
  --description "nautilus Snapshot" \
  --tag-specifications 'ResourceType=snapshot,Tags=[{Key=Name,Value=nautilus-vol-ss}]' \
  --region us-east-1 \
  --query "SnapshotId" \
  --output text)
```

Display the created Snapshot ID:

```bash
echo $SNAPSHOT_ID
```

## 3. Wait Until the Snapshot Is Completed

Use the AWS CLI waiter:

```bash
aws ec2 wait snapshot-completed \
  --snapshot-ids "$SNAPSHOT_ID" \
  --region us-east-1
```

The command returns after AWS reports the snapshot as completed.

## 4. Verify the Snapshot

```bash
aws ec2 describe-snapshots \
  --snapshot-ids "$SNAPSHOT_ID" \
  --region us-east-1 \
  --query "Snapshots[*].[SnapshotId,VolumeId,State,Description]" \
  --output table
```

The expected state should be:

```text
completed
```

## 5. Verify the Snapshot Name Tag

```bash
aws ec2 describe-tags \
  --filters \
    "Name=resource-id,Values=$SNAPSHOT_ID" \
    "Name=key,Values=Name" \
  --region us-east-1 \
  --query "Tags[*].[Key,Value]" \
  --output table
```

Expected value:

```text
Name    nautilus-vol-ss
```

## Quick CLI Workflow

```bash
VOLUME_ID=$(aws ec2 describe-volumes \
  --filters "Name=tag:Name,Values=nautilus-vol" \
  --region us-east-1 \
  --query "Volumes[0].VolumeId" \
  --output text)

SNAPSHOT_ID=$(aws ec2 create-snapshot \
  --volume-id "$VOLUME_ID" \
  --description "nautilus Snapshot" \
  --tag-specifications 'ResourceType=snapshot,Tags=[{Key=Name,Value=nautilus-vol-ss}]' \
  --region us-east-1 \
  --query "SnapshotId" \
  --output text)

aws ec2 wait snapshot-completed \
  --snapshot-ids "$SNAPSHOT_ID" \
  --region us-east-1

aws ec2 describe-snapshots \
  --snapshot-ids "$SNAPSHOT_ID" \
  --region us-east-1 \
  --query "Snapshots[*].[SnapshotId,VolumeId,State,Description]" \
  --output table
```