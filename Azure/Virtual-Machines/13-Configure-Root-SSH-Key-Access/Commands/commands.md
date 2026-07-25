# Commands Used – Configure Passwordless Root SSH Access

This file contains the complete command sequence used to configure SSH public key authentication for the `root` user on the Azure virtual machine `xfusion-vm`.

> Replace `<VM_PUBLIC_IP>` with the public IP address assigned to the VM.

```bash
# ============================================================
# Azure Client Host
# ============================================================

# Display the root user's SSH public key
sudo cat /root/.ssh/id_rsa.pub


# ============================================================
# Connect to xfusion-vm using the default Azure user
# ============================================================

ssh azureuser@<VM_PUBLIC_IP>

# Verify the currently authenticated user
whoami


# ============================================================
# Configure SSH access for the root user
# ============================================================

# Create the root SSH directory if it does not already exist
sudo mkdir -p /root/.ssh

# Open the root authorized_keys file
# Paste the public key obtained from /root/.ssh/id_rsa.pub
sudo nano /root/.ssh/authorized_keys

# Set root as the owner of the SSH directory and its contents
sudo chown -R root:root /root/.ssh

# Set secure permissions on the SSH directory
sudo chmod 700 /root/.ssh

# Set secure permissions on the authorized_keys file
sudo chmod 600 /root/.ssh/authorized_keys


# ============================================================
# Verify the SSH configuration
# ============================================================

# Display the configured public key
sudo cat /root/.ssh/authorized_keys

# Verify .ssh directory ownership and permissions
sudo ls -ld /root/.ssh

# Verify authorized_keys ownership and permissions
sudo ls -l /root/.ssh/authorized_keys


# ============================================================
# Test passwordless root SSH authentication
# ============================================================

# Exit the azureuser SSH session
exit

# Connect directly to the VM as root
ssh root@<VM_PUBLIC_IP>

# Verify that the authenticated user is root
whoami

# Verify that the connected VM is xfusion-vm
hostname
```

## Expected Final Verification

After successfully connecting as root:

```text
root@xfusion-vm:~# whoami
root

root@xfusion-vm:~# hostname
xfusion-vm
```

A successful connection without a password prompt confirms that SSH public key authentication for the root user has been configured correctly.

## Important Security Notes

- Only the **public SSH key** should be copied to the VM.
- The private SSH key must remain securely stored on the client host.
- Never commit SSH private keys to Git or GitHub.
- `/root/.ssh` should use `700` permissions.
- `/root/.ssh/authorized_keys` should use `600` permissions.
- Both should be owned by `root:root`.