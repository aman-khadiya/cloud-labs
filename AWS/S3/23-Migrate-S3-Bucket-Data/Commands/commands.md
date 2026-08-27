# Commands — S3 Bucket Data Migration

This document contains the AWS CLI commands used to create the destination S3 bucket, migrate the data, and verify data consistency.

---

## 1. Create Destination S3 Bucket

Created the new private S3 bucket `devops-sync-24093` in the `us-east-1` region.

```bash
aws s3api create-bucket \
  --bucket devops-sync-24093 \
  --region us-east-1
```

---

## 2. Verify Destination Bucket

Verified that the destination bucket exists and is located in the required region.

```bash
aws s3api head-bucket \
  --bucket devops-sync-24093
```

Expected verification:

```text
BucketRegion: us-east-1
BucketArn: arn:aws:s3:::devops-sync-24093
```

---

## 3. Preview Data Migration

Used `--dryrun` to preview the synchronization before performing the actual migration.

```bash
aws s3 sync \
  s3://devops-s3-20581 \
  s3://devops-sync-24093 \
  --dryrun
```

---

## 4. Migrate Data

Copied/synchronized the complete dataset from the existing source bucket to the new destination bucket.

```bash
aws s3 sync \
  s3://devops-s3-20581 \
  s3://devops-sync-24093
```

---

## 5. Verify Source Bucket

Displayed the total number of objects and total data size in the source bucket.

```bash
echo "SOURCE:"
aws s3 ls s3://devops-s3-20581 --recursive --summarize | tail -n 2
```

Expected result:

```text
Total Objects: 3782
Total Size: 110039745
```

---

## 6. Verify Destination Bucket

Displayed the total number of objects and total data size in the destination bucket.

```bash
echo "DESTINATION:"
aws s3 ls s3://devops-sync-24093 --recursive --summarize | tail -n 2
```

Expected result:

```text
Total Objects: 3782
Total Size: 110039745
```

---

## 7. Data Consistency Verification

Compared the source and destination bucket summaries.

| Verification | Source | Destination |
|---|---:|---:|
| **Total Objects** | 3,782 | 3,782 |
| **Total Size** | 110,039,745 bytes | 110,039,745 bytes |

The object count and total size matched exactly, confirming successful data migration.

---

## 8. Complete Command Summary

```bash
# Create destination bucket
aws s3api create-bucket \
  --bucket devops-sync-24093 \
  --region us-east-1

# Verify destination bucket
aws s3api head-bucket \
  --bucket devops-sync-24093

# Preview synchronization
aws s3 sync \
  s3://devops-s3-20581 \
  s3://devops-sync-24093 \
  --dryrun

# Migrate complete dataset
aws s3 sync \
  s3://devops-s3-20581 \
  s3://devops-sync-24093

# Verify source bucket
echo "SOURCE:"
aws s3 ls s3://devops-s3-20581 --recursive --summarize | tail -n 2

# Verify destination bucket
echo "DESTINATION:"
aws s3 ls s3://devops-sync-24093 --recursive --summarize | tail -n 2
```

---

## Result

- Destination bucket `devops-sync-24093` created successfully.
- Data migrated from `devops-s3-20581`.
- Source: **3,782 objects**
- Destination: **3,782 objects**
- Source size: **110,039,745 bytes**
- Destination size: **110,039,745 bytes**
- Data consistency verified successfully.