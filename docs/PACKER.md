# VMware/Packer Builder

The `packer/` directory contains starter VMware ISO builders.

Example:

```bash
packer init packer/ubuntu-vmware.pkr.hcl
packer build \
  -var 'iso_url=/path/to/ubuntu.iso' \
  -var 'iso_checksum=sha256:<hash>' \
  packer/ubuntu-vmware.pkr.hcl
```

The templates are intentionally conservative starter files. You will normally add distro-specific boot commands or autoinstall/preseed files for fully unattended ISO installs.

For VMware Workstation/Fusion, verify the HashiCorp VMware plugin, local ISO, guest OS type, and SSH bootstrap user before running a long build.
