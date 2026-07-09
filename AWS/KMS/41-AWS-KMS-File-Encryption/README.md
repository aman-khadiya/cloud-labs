## Task Description

The objective of this task was to create an AWS KMS symmetric key, encrypt the provided `SensitiveData.txt` file, save the encrypted output as `EncryptedData.bin`, decrypt the file, and verify that the decrypted content matched the original.

# AWS KMS - File Encryption and Decryption

## 📌 Objective

Create a customer-managed AWS KMS symmetric key, encrypt a sensitive file, decrypt it, and verify that the decrypted file matches the original.

---

## 🛠 AWS Services Used

- AWS KMS
- AWS CLI

---

## 📚 Key Concepts

- Customer Managed Key (CMK)
- Symmetric Encryption
- Encryption
- Decryption
- Base64 Encoding
- Ciphertext

---

## 📋 Steps Performed

### Step 1

Created a symmetric KMS key.

Alias:

```
datacenter-KMS-Key
```

---

### Step 2

Encrypted the file

```
SensitiveData.txt
```

using AWS KMS.

---

### Step 3

Decoded the Base64 ciphertext and stored it as

```
EncryptedData.bin
```

---

### Step 4

Decrypted the encrypted binary file.

---

### Step 5

Compared the decrypted file with the original file using

```
diff
```

Both files matched successfully.

---

## 💻 Commands Used

### Encrypt

```bash
aws kms encrypt \
--key-id alias/datacenter-KMS-Key \
--plaintext fileb:///root/SensitiveData.txt \
--query CiphertextBlob \
--output text | base64 --decode > /root/EncryptedData.bin
```

### Decrypt

```bash
aws kms decrypt \
--ciphertext-blob fileb:///root/EncryptedData.bin \
--output text \
--query Plaintext | base64 --decode > /root/DecryptedData.txt
```

### Verify

```bash
diff /root/SensitiveData.txt /root/DecryptedData.txt
```

---

## ✅ Verification

- KMS Key Created Successfully
- File Encrypted Successfully
- Binary Ciphertext Generated
- File Decrypted Successfully
- Decrypted File Matches Original

---

## 📂 Project Structure

```
41-AWS-KMS-File-Encryption
│
├── README.md
├── screenshots
└── scripts
```

---

## 📷 Screenshots

- Task Description
- KMS Key Created
- Encryption Command
- EncryptedData.bin Created
- Decryption Verification
- Task Completed

---

## 🎯 Learning Outcomes

- Create Customer Managed KMS Keys
- Encrypt Files using AWS CLI
- Decrypt Files using AWS CLI
- Understand Symmetric Encryption
- Verify File Integrity

---

## 💼 Interview Questions

### What is AWS KMS?

AWS Key Management Service is a managed service used to create, manage, and use encryption keys.

---

### What is a Symmetric Key?

A single key is used for both encryption and decryption.

---

### Why do we use Base64 Decode?

AWS KMS returns encrypted data in Base64 format. It is decoded into binary so it can be stored as a binary encrypted file.

---

### What is Ciphertext?

Ciphertext is encrypted data that cannot be read without the correct encryption key.