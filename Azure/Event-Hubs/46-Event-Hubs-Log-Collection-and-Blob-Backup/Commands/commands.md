# Commands Used

## Verify Script

```bash
cat /home/azureuser/send_logs.py
```

## Generate SSH Key (Client Host)

```bash
ssh-keygen -t rsa -b 4096
```

## Copy Script to VM

```bash
scp /root/send_logs.py azureuser@<VM_PUBLIC_IP>:/home/azureuser/
```

## Connect to VM

```bash
ssh azureuser@<VM_PUBLIC_IP>
```

## Verify Copied Script

```bash
ls -l /home/azureuser
```

## Install Python Pip

```bash
sudo apt update
sudo apt install -y python3-pip
```

## Verify Pip

```bash
pip3 --version
```

## Install Azure SDK

```bash
pip3 install --break-system-packages azure-eventhub azure-storage-blob
```

## Execute Script

```bash
python3 /home/azureuser/send_logs.py
```