# Commands Used

> This lab was completed using the AWS Management Console.

## AWS CLI Equivalent

```bash
aws ec2 attach-network-interface \
    --network-interface-id eni-xxxxxxxx \
    --instance-id i-xxxxxxxx \
    --device-index 1
```

## Verify Attachment

```bash
aws ec2 describe-network-interfaces \
    --network-interface-ids eni-xxxxxxxx
```