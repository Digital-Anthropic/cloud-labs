
# Installation

To install Terraform, download the appropriate package for your operating system
from the [official Terraform website](https://www.terraform.io/downloads.html)
and follow the installation instructions.

## For Windows

### Windows AMD64 binary

Link: <https://releases.hashicorp.com/terraform/1.8.0/terraform_1.8.0_windows_amd64.zip>

### Windows 386 binary

Link: <https://releases.hashicorp.com/terraform/1.8.0/terraform_1.8.0_windows_386.zip>

## For macOS

### Package manager

```bash
 brew tap hashicorp/tap
 brew install hashicorp/tap/terraform
```

### Binary AMD64

LINK: <https://releases.hashicorp.com/terraform/1.8.0/terraform_1.8.0_darwin_amd64.zip>

### Binary ARM64

LINK: <https://releases.hashicorp.com/terraform/1.8.0/terraform_1.8.0_darwin_arm64.zip>

## For Ubuntu

```bash
 wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
 echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
 sudo apt update && sudo apt install terraform
```

## For CentOS/RHEL

```bash
 sudo yum install -y yum-utils
 sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
 sudo yum -y install terraform
```

## For Fedora

```bash
 sudo dnf install -y dnf-plugins-core
 sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
 sudo dnf -y install terraform
```

## for Amazon Linux

```bash
 sudo yum install -y yum-utils shadow-utils
 sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
 sudo yum -y install terraform
```
