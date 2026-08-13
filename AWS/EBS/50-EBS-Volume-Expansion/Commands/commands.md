# Commands — AWS EBS Volume Expansion

> Region: `us-east-1`

## 1. Identify `devops-ec2`

```bash
aws ec2 describe-instances \
--filters "Name=tag:Name,Values=devops-ec2" \
--query "Reservations[].Instances[].{InstanceId:InstanceId,State:State.Name,KeyName:KeyName,PublicIP:PublicIpAddress,RootDevice:RootDeviceName,VolumeId:BlockDeviceMappings[].Ebs.VolumeId}" \
--output table \
--region us-east-1
```

Expected information:

```text
Instance: devops-ec2
Root device: /dev/xvda
Volume: vol-0d334880d52bf4593
```

## 2. Confirm the EBS Volume

```bash
aws ec2 describe-volumes \
--volume-ids vol-0d334880d52bf4593 \
--query "Volumes[].{VolumeId:VolumeId,SizeGiB:Size,Type:VolumeType,State:State,Device:Attachments[0].Device}" \
--output table \
--region us-east-1
```

Expected:

```text
SizeGiB: 8
Type: gp3
State: in-use
Device: /dev/xvda
```

## 3. Verify Key Pair

### Local private-key fingerprint

```bash
ssh-keygen -y -f /root/devops-keypair.pem | ssh-keygen -E md5 -lf -
```

### AWS key-pair fingerprint

```bash
aws ec2 describe-key-pairs \
--key-names devops-keypair \
--query "KeyPairs[0].{Name:KeyName,Type:KeyType,Fingerprint:KeyFingerprint}" \
--output table \
--region us-east-1
```

> In this lab, the provided key did not match the registered key pair, so EC2 Instance Connect was used for access.

## 4. Modify EBS Volume: 8 GiB → 12 GiB

```bash
aws ec2 modify-volume \
--volume-id vol-0d334880d52bf4593 \
--size 12 \
--region us-east-1
```

## 5. Check Volume Modification

```bash
aws ec2 describe-volumes-modifications \
--volume-ids vol-0d334880d52bf4593 \
--query "VolumesModifications[].{OriginalSize:OriginalSize,TargetSize:TargetSize,Progress:Progress,State:ModificationState}" \
--output table \
--region us-east-1
```

Expected:

```text
OriginalSize: 8
TargetSize: 12
State: optimizing
```

## 6. Identify Instance Availability Zone

```bash
aws ec2 describe-instances \
--instance-ids i-0a76811ceb761a8f9 \
--query "Reservations[0].Instances[0].{AZ:Placement.AvailabilityZone,Subnet:SubnetId,PublicIP:PublicIpAddress}" \
--output table \
--region us-east-1
```

Expected:

```text
AZ: us-east-1c
PublicIP: 54.211.4.61
```

## 7. EC2 Instance Connect

Inject the temporary public key:

```bash
aws ec2-instance-connect send-ssh-public-key \
--instance-id i-0a76811ceb761a8f9 \
--instance-os-user ec2-user \
--ssh-public-key "$(ssh-keygen -y -f /root/devops-keypair.pem)" \
--availability-zone us-east-1c \
--region us-east-1
```

Expected:

```text
"Success": true
```

## 8. SSH to EC2

```bash
ssh -o IdentitiesOnly=yes -i /root/devops-keypair.pem ec2-user@54.211.4.61
```

## 9. Inspect Block Device and Filesystem

```bash
lsblk
```

```bash
df -hT /
```

Expected before partition expansion:

```text
xvda      12G disk
└─xvda1    8G part /
```

And filesystem:

```text
/dev/xvda1   xfs   8.0G   ...   /
```

## 10. Expand Root Partition

```bash
sudo growpart /dev/xvda 1
```

Expected:

```text
CHANGED: partition=1
```

Verify:

```bash
lsblk
```

Expected:

```text
xvda      12G disk
└─xvda1   12G part /
```

## 11. Expand XFS Filesystem

Because the root filesystem is XFS:

```bash
sudo xfs_growfs /
```

## 12. Final Verification

```bash
lsblk
```

```bash
df -hT /
```

Expected:

```text
Filesystem     Type  Size  Used  Avail  Use%  Mounted on
/dev/xvda1     xfs   12G   1.6G  11G    13%   /
```

## 13. Final State

```text
EBS Volume        12 GiB
Root Partition    12 GiB
Filesystem        XFS
Mount             /
Status            Completed
```
