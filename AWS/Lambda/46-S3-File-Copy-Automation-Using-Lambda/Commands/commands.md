# Commands Used

## 1. Verify Lambda Function Update Status

```bash
aws lambda get-function-configuration \
  --function-name xfusion-copyfunction \
  --query "LastUpdateStatus"
```

---

## 2. Package the Lambda Function

```bash
cd /root

cp lambda-function.py lambda_function.py

zip -j function.zip lambda_function.py
```

---

## 3. Update Lambda Function Code

```bash
aws lambda update-function-code \
  --function-name xfusion-copyfunction \
  --zip-file fileb:///root/function.zip
```

---

## 4. Upload Test File

```bash
aws s3 cp /root/sample.zip s3://xfusion-public-4748
```

---

## 5. Verify File Copy

```bash
aws s3 ls s3://xfusion-private-16849
```

---

## 6. Verify DynamoDB Log Entry

```bash
aws dynamodb scan \
  --table-name xfusion-S3CopyLogs
```

---

## 7. CloudWatch Debugging

```bash
aws logs describe-log-streams \
  --log-group-name /aws/lambda/xfusion-copyfunction \
  --order-by LastEventTime \
  --descending
```

```bash
aws logs get-log-events \
  --log-group-name /aws/lambda/xfusion-copyfunction \
  --log-stream-name "<LogStreamName>"
```