# Terraform and Infrastructure as Code (IAC) Documentation

## Table of Contents

1. [Introduction](#introduction)
2. [Infrastructure as Code (IAC)](#infrastructure-as-code-iac)
    - [Benefits of IAC](#benefits-of-iac)
3. [Terraform Overview](#terraform-overview)
    - [Declarative Configuration](#declarative-configuration)
    - [State Management](#state-management)
    - [Modular Architecture](#modular-architecture)
    - [Plan and Apply Workflow](#plan-and-apply-workflow)
    - [Multi-Cloud Support](#multi-cloud-support)
4. [Terraform Basics](#terraform-basics)
    - [Providers](#providers)
    - [Resources](#resources)
    - [Variables](#variables)
    - [Outputs](#outputs)
    - [Data Sources](#data-sources)
    - [Local Values](#local-values)
    - [Expressions](#expressions)
    - [Functions](#functions)
    - [Provisioners](#provisioners)
    - [Backend](#backend)
    - [terraform.tfvars](#terraformtfvars)
    - [Modules](#modules)
    - [Cloud-Init](#cloud-init)
    - [Network Configuration](#network-configuration)
    - [Provider Installation](#provider-installation)
    - [Workspaces](#workspaces)
    - [State Management Commands](#state-management-commands)
    - [Locking](#locking)
    - [Sensitive Data](#sensitive-data)
5. [Installation](#installation)
6. [Getting Started](#getting-started)

---

## Introduction

Terraform is an open-source Infrastructure as Code (IAC) tool created by HashiCorp. It allows you to define and provision infrastructure using a declarative configuration language. This documentation provides an overview of Terraform, its components, the benefits of adopting Infrastructure as Code practices and also how to get started with the code provided.

---

## Infrastructure as Code (IAC)

Infrastructure as Code (IAC) is a key concept in modern DevOps and cloud computing practices. It refers to the process of managing and provisioning infrastructure using code and automation rather than manual processes.

### Benefits of IAC

#### Version Control

- **Code Repositories**: Store infrastructure code in version control systems like Git, enabling versioning, history tracking, and collaboration.
- **Code Reviews**: Implement code review practices to ensure quality, security, and compliance of infrastructure code changes.

#### Consistency and Reproducibility

- **Consistent Deployments**: Ensure consistent and repeatable deployments across different environments (development, staging, production) by using code to define infrastructure.
- **Environment Parity**: Maintain consistent configurations between development, testing, and production environments to reduce discrepancies and deployment issues.

#### Automation and Efficiency

- **Automated Provisioning**: Automate the provisioning, configuration, and management of infrastructure, reducing manual intervention and human errors.
- **Efficient Scaling**: Dynamically scale infrastructure resources to handle increased workload demands, improving performance and reliability.

#### Collaboration and Knowledge Sharing

- **Shared Understanding**: Facilitate collaboration between development, operations, and other teams by using a common language and approach to define infrastructure.
- **Reusable Components**: Create reusable infrastructure code modules and templates that can be shared across teams and projects to improve productivity and standardization.

---

## Terraform Overview

### Declarative Configuration

Terraform uses a declarative configuration language called HashiCorp Configuration Language (HCL) to define the infrastructure and resources. With HCL, you can specify the desired state of your infrastructure, and Terraform will automatically determine the actions to achieve that state.

\`\`\`hcl
resource "libvirt_network" "example" {
  name = "terraform-network"
  mode = "nat"
}
\`\`\`

### State Management

Terraform maintains a consistent state of your infrastructure by tracking changes and dependencies between resources. The \`tfstate\` file stores the current state of your infrastructure, allowing Terraform to understand which resources need to be created, updated, or destroyed.

### Modular Architecture

Terraform allows you to organize your configurations into reusable modules. Modules are self-contained packages of Terraform configurations that can be used across different projects and environments, making it easier to manage and maintain complex infrastructure.

\`\`\`hcl
module "vm" {
  source = "./modules/vm"
  
  name   = "terraform-vm"
  memory = "512"
  vcpu   = "1"
}
\`\`\`

### Plan and Apply Workflow

Terraform provides a \`plan\` and \`apply\` workflow that allows you to preview and apply changes to your infrastructure in a controlled manner. The \`terraform plan\` command shows you a preview of the actions that Terraform will take, while \`terraform apply\` applies those changes to provision or update your infrastructure.

\`\`\`bash
terraform plan
terraform apply
\`\`\`

### Multi-Cloud Support

Terraform supports provisioning and managing resources across multiple cloud providers and on-premises environments using a single tool. This provides flexibility and avoids vendor lock-in, allowing you to use the best services from different providers to meet your specific requirements.

\`\`\`hcl
provider "libvirt" {
  uri = "qemu:///system"
}
\`\`\`

---

## Terraform Basics

### Providers

Providers are responsible for managing the lifecycle of a resource: create, read, update, delete. They determine how to communicate with the respective APIs and perform CRUD operations.

\`\`\`hcl
provider "libvirt" {
  uri = "qemu:///system"
}
\`\`\`

### Resources

Resources are the building blocks of your infrastructure. They define the desired state of a particular object, such as a virtual machine, network, or DNS record.

\`\`\`hcl
resource "libvirt_domain" "example" {
  name   = "terraform-vm"
  memory = "512"
  vcpu   = "1"
}
\`\`\`

### Variables

Variables allow you to parameterize your configurations, making them more reusable and flexible. They can be defined in separate `variables.tf` files or in the main configuration.

\`\`\`hcl
variable "vm_name" {
  description = "Name of the virtual machine"
  default     = "terraform-vm"
}
\`\`\`

### Outputs

Outputs allow you to extract and display information from your Terraform configuration after it has been applied. This is useful for retrieving IP addresses, resource IDs, or any other relevant data.

\`\`\`hcl
output "vm_ip" {
  value = libvirt_domain.example.network_interface.0.addresses.0
}
\`\`\`

### Data Sources

Data sources allow you to fetch information from external sources or existing infrastructure. This can be useful for retrieving information about existing resources to be used in your configurations.

\`\`\`hcl
data "libvirt_network" "example" {
  name = "existing-network"
}
\`\`\`

### Local Values

Local values allow you to define intermediate values that can be reused within your Terraform configuration files. They are useful for avoiding repetition and improving readability.

\`\`\`hcl
locals {
  common_tags = {
    Environment = "Production"
    Owner       = "DevOps Team"
  }
}
\`\`\`

### Expressions

Terraform supports a wide range of expressions for manipulating and referencing values within your configurations, such as arithmetic operations, string manipulation, and more.

\`\`\`hcl
resource "libvirt_domain" "example" {
  name   = "vm-${count.index}"
  memory = var.memory
  vcpu   = "1"
}
\`\`\`

### Functions

Terraform provides built-in functions for string manipulation, mathematical operations, and more. These functions can be used within your configurations to generate or transform values.

\`\`\`hcl
output "vm_names" {
  value = join(",", libvirt_domain.example.*.name)
}
\`\`\`

### Provisioners

Provisioners allow you to run scripts or commands on a resource after it has been created or destroyed. This can be useful for tasks such as installing software or configuring services.

\`\`\`hcl
resource "libvirt_domain" "example" {
  name   = "terraform-vm"
  memory = "512"
  vcpu   = "1"

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx"
    ]
  }
}
\`\`\`

### Backend

Backends define where Terraform will store state files, allowing for collaboration and state management across teams. Common backends include local, S3, and Terraform Cloud.

\`\`\`hcl
terraform {
  backend "s3" {
    bucket = "terraform-state"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
\`\`\`

### terraform.tfvars

The `terraform.tfvars` file allows you to set values for your variables, making it easier to manage and share configuration settings.

\`\`\`hcl

vm_name = "terraform-vm"
memory  = "512"
vcpu    = "1"
\`\`\`

### Modules

Modules enable code reusability and allow you to organize your Terraform configurations into reusable components. They can be used to encapsulate and abstract complex configurations.

\`\`\`hcl
module "vm" {
  source = "./modules/vm"
  
  name   = "terraform-vm"
  memory = "512"
  vcpu   = "1"
}
\`\`\`

### Cloud-Init

Cloud-Init is a widely used approach to initialize cloud instances with user data. It's commonly used with virtual machines to automate the configuration process.

\`\`\`hcl
resource "libvirt_cloudinit_disk" "example" {
  name    = "cloud-init-disk"
  user_data = file("cloudinit.cfg")
}
\`\`\`

### Network Configuration

You can define network configurations to manage the networking settings of your virtual machines.

\`\`\`hcl
resource "libvirt_network" "example" {
  name = "terraform-network"
  mode = "nat"
  xml_config = file("network_config.cfg")
}
\`\`\`

### Provider Installation

To install a Terraform provider, you can use the `terraform init` command to download and install the required provider plugin.

\`\`\`bash
terraform init
\`\`\`

For the `dmvicar/libvirt` provider, you can specify it in your Terraform configuration:

\`\`\`hcl
provider "libvirt" {
  uri = "qemu:///system"
}
\`\`\`

### Workspaces

Workspaces allow you to manage multiple environments (e.g., development, staging, production) within a single Terraform configuration.

\`\`\`bash
terraform workspace new dev
terraform workspace select dev
\`\`\`

### State Management Commands

Terraform provides commands to manage the state file, such as `terraform state list`, `terraform state show`, and `terraform state rm`.

\`\`\`bash
terraform state list
terraform state show libvirt_domain.example
\`\`\`

### Locking

State file locking prevents concurrent runs that can lead to conflicts and inconsistencies in the infrastructure.

\`\`\`hcl
terraform {
  lock {
    enabled = true
  }
}
\`\`\`

### Sensitive Data

You can mark sensitive variables to prevent them from being displayed in the console output or stored in the state file.

\`\`\`hcl
variable "password" {
  description = "The database password"
  sensitive   = true
}
\`\`\`

---

## Installation

To install Terraform, download the appropriate package for your operating system from the [official Terraform website](https://www.terraform.io/downloads.html) and follow the installation instructions.

---

## Getting Started

1. **Installing virtualization(KVM Libvirt)**:
    For us to get started we will need to have virtualization enabled on our host machine. Check this link below and follow the steps to install kvm on your machine.
    <https://www.linuxtechi.com/how-to-install-kvm-on-ubuntu-22-04/>
<!-- 
2. **Add provider dmacvicar/libvirt to terraform**:
    In order to get started with our terraform project we will need the provider, dmacvicar/libvirt in our case. Follow the steps below to achieve this goal. Note that you will have to adjust the version(0.7.6) and os_architecture(linux_amd64) to fit your specs and requirements.

    \`\`\`bash
    mkdir -p ~/.local/share/terraform/plugins/registry.terraform.io/dmacvicar/libvirt/0.7.6/linux_amd64
    cd ~/.local/share/terraform/plugins/registry.terraform.io/dmacvicar/libvirt/0.7.6/linux_amd64
    \`\`\`

    After creating those directories we will need to download the release zip file of the version/architecture needed. Take a look at the link below and change the wget command to fit you.
    <https://github.com/dmacvicar/terraform-provider-libvirt/releases>

    \`\`\`bash
    wget <https://github.com/dmacvicar/terraform-provider-libvirt/releases/download/v0.7.6/terraform-provider-libvirt_0.7.6_linux_amd64.zip>
    \`\`\`

    When the download is finished you will have a zip file in your directory. Yes, we need to unzip it. C&P the below command to unzip the file. NOTE: You can remove the zip file after extraction.

    \`\`\`bash
    unzip terraform-provider-libvirt_0.7.6_linux_amd64.zip
    \`\`\`

3. **Download Ubuntu image for VMs**:
    To install Ubuntu on our virtual machines we will need the OS image. I will leave a link below from where you can find some Ubuntu images:
    <https://cloud-images.ubuntu.com/jammy/current/>.

    ###########I suggest using the KVM-optimised kernel one(<https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64-disk-kvm.img>).

    After you have the .img file in your local machine, we will need to simply extend that image with at least 10GB using QEMU. Use the command below to do that.

    \`\`\`bash
    qemu-img resize path/to/jammy-server-cloudimg-amd64-disk-kvm.img +10G
    \`\`\` -->

---

By adopting Terraform and Infrastructure as Code practices, organizations can achieve improved agility, scalability, and consistency in managing their infrastructure, leading to faster development cycles, reduced costs, and increased operational efficiency.
