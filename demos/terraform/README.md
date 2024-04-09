# Terraform and Infrastructure as Code (IAC) Documentation

## Table of Contents

1. [Introduction](#introduction)
2. [Infrastructure as Code (IAC)](#infrastructure-as-code-iac)
    - [Benefits of IAC](#benefits-of-iac)
3. [Terraform Overview](#terraform-overview)
    - [Declarative Configuration](#declarative-configuration)
    - [State Management](#state-management)
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
    - [terraform.tfvars](#terraformtfvars)
    - [Modules](#modules)
    - [Cloud-Init](#cloud-init)
    - [Network Configuration](#network-configuration)
    - [Provider and Module Installation](#provider-and-module-installation)
    - [Workspaces](#workspaces)
    - [State Management Commands](#state-management-commands)
    - [Locking](#locking)
    - [Sensitive Data](#sensitive-data)
5. [Installation](#installation)

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

```hcl
resource "libvirt_network" "example" {
  name = "terraform-network"
  mode = "nat"
}
```

### State Management

Terraform maintains a consistent state of your infrastructure by tracking changes and dependencies between resources. The `tfstate` file stores the current state of your infrastructure, allowing Terraform to understand which resources need to be created, updated, or destroyed.

#### Best Practices for State Management

- **Secure Storage**: Ensure the `tfstate` file is stored securely to protect sensitive information. Avoid storing it in plaintext or in public repositories.
- **Version Control**: Although the state file contains sensitive and critical information, it's recommended to maintain it in version control systems with proper access controls.
- **Collaboration**: For team-based projects, storing the state file in a shared location enables collaboration and ensures that all team members are working with the same infrastructure state.
- **Backup**: Regularly backup the state file to prevent data loss in case of accidental deletion or corruption.

#### Storing Terraform State in Azure Storage Account

To store the Terraform state file in an Azure Storage Account, you can use the following backend configuration:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name   = "myResourceGroup"
    storage_account_name  = "myterraformstate"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}
```

For more information on configuring Azure Storage as a Terraform backend, refer to the [AzureRM Backend Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/backend).

#### Storing Terraform State in AWS S3 Bucket

To store the Terraform state file in an AWS S3 Bucket, you can use the following backend configuration:

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "terraform.tfstate"
    region         = "us-west-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}
```

For more information on configuring AWS S3 as a Terraform backend, refer to the [AWS S3 Backend Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/backends/s3).

By following these best practices and utilizing cloud storage solutions like Azure Storage Account or AWS S3 Bucket, you can effectively manage and share your Terraform state across developers and ensure consistency in your infrastructure deployments.

### Plan and Apply Workflow

Terraform provides a series of commands to manage and apply your infrastructure configurations in a systematic manner. Below are the key steps involved in the Terraform workflow, from initializing your workspace to applying the configuration and checking the resources using `virsh`.

#### Initialize Terraform Workspace

Before applying any Terraform configurations, it's essential to initialize the Terraform workspace. This step downloads the required provider plugins and initializes the backend.

```bash
terraform init
```

#### Preview Infrastructure Changes with `terraform plan`

The `terraform plan` command is used to generate an execution plan that describes the actions Terraform will take to achieve the desired state defined in your configuration files. This plan helps you understand the changes that will be applied to your infrastructure without actually making any modifications.

```bash
terraform plan -out=plan
```

The `-out` flag allows you to save the generated plan to a file named `plan`, which can be used later with `terraform apply`.

#### Apply Infrastructure Changes with `terraform apply`

After reviewing the execution plan and ensuring everything looks correct, you can apply the changes to your infrastructure using the `terraform apply` command. This command reads the saved plan from the `plan` file and applies the changes to provision or update your infrastructure accordingly.

```bash
terraform apply "plan"
```

By following this `plan` and `apply` workflow, you can preview and apply changes to your infrastructure in a controlled and systematic manner, ensuring consistency and reliability in your Terraform deployments.

#### Apply Terraform Configuration

After reviewing the execution plan and ensuring everything looks correct, you can apply the Terraform configuration to create or update the infrastructure resources.

```bash
terraform apply
```

#### Check Created Resources with `virsh`

After successfully applying the Terraform configuration, you can use the `virsh` command to list the virtual machines managed by libvirt and verify that the resources were created as expected.

```bash
virsh list --all
```

This workflow ensures a controlled and systematic approach to managing your infrastructure using Terraform, from initialization and planning to applying the configuration and verifying the created resources with `virsh`.

### Multi-Cloud Support

Terraform supports provisioning and managing resources across multiple cloud providers and on-premises environments using a single tool. This provides flexibility and avoids vendor lock-in, allowing you to use the best services from different providers to meet your specific requirements.

#### Using Multiple `azurerm` Providers with Resources

You can specify multiple `azurerm` providers in your Terraform configuration to manage resources across different Azure regions or subscriptions. Below is an example that demonstrates how to use two `azurerm` providers to create resources in two different Azure Resource Groups (RGs):

```hcl
provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias   = "eastus"
  features {}
}

resource "azurerm_resource_group" "rg_westus" {
  provider = azurerm
  name     = "rg-westus"
  location = "westus"
}

resource "azurerm_resource_group" "rg_eastus" {
  provider = azurerm.eastus
  name     = "rg-eastus"
  location = "eastus"
}
```

#### Using `azurerm` and `aws` Providers with Resources

You can also use both `azurerm` and `aws` providers in the same Terraform configuration. Below is an example that demonstrates how to use one `aws` provider and two `azurerm` providers to manage resources across AWS and Azure:

```hcl
provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias   = "eastus"
  features {}
}

provider "aws" {
  region = "us-west-1"
}

resource "azurerm_resource_group" "rg_westus" {
  provider = azurerm
  name     = "rg-westus"
  location = "westus"
}

resource "azurerm_resource_group" "rg_eastus" {
  provider = azurerm.eastus
  name     = "rg-eastus"
  location = "eastus"
}

resource "aws_s3_bucket" "example" {
  provider = aws
  bucket   = "my-example-bucket"
  acl      = "private"
}
```

#### Specifying Providers in Resources

When using multiple providers, you can specify which provider to use for each resource using the `provider` attribute. This allows you to control which cloud provider or environment the resource belongs to.

```hcl
resource "azurerm_virtual_network" "vnet_westus" {
  provider            = azurerm
  name                = "vnet-westus"
  resource_group_name = azurerm_resource_group.rg_westus.name
  location            = azurerm_resource_group.rg_westus.location
}

resource "aws_vpc" "example" {
  provider             = aws
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}
```

By leveraging Terraform's multi-cloud support, you can manage resources across different cloud providers and environments using a unified and consistent approach, enabling you to optimize costs and meet specific requirements effectively.

---

## Terraform Basics

### Providers

Providers are responsible for managing the lifecycle of a resource: create, read, update, delete. They determine how to communicate with the respective APIs and perform CRUD operations.

```hcl
provider "libvirt" {
  uri = "qemu:///system"
}
```

### Resources

Resources are the building blocks of your infrastructure. They define the desired state of a particular object, such as a virtual machine, network, or DNS record.

```hcl
resource "libvirt_domain" "example" {
  name   = "terraform-vm"
  memory = "512"
  vcpu   = "1"
}
```

### Variables

Variables allow you to parameterize your configurations, making them more reusable and flexible. They can be defined in separate `variables.tf` files or in the main configuration.

#### Defining Variables in `variables.tf`

You can define variables in a separate `variables.tf` file within your Terraform configuration directory. Below is an example of defining a variable named `location`:

```hcl
variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "eastus"
}
```

#### Using Variables in Resources

Once a variable is defined, you can reference it within resources using the `${var.variable_name}` syntax. Here's an example that demonstrates how to use the `location` variable in an `azurerm_resource_group` resource:

```hcl
provider "azurerm" {
  features {}
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "eastus"
}

resource "azurerm_resource_group" "example_rg" {
  name     = "example-resource-group"
  location = var.location
}
```

In the example above, the `location` attribute of the `azurerm_resource_group` resource is set to the value of the `location` variable using `${var.location}`. This allows you to parameterize the resource configuration and easily change the Azure region where the resource group will be created by modifying the `location` variable value.

By using variables in your Terraform configurations, you can create more reusable and flexible infrastructure code, making it easier to manage and maintain your infrastructure across different environments and configurations.

### Outputs

Outputs allow you to extract and display information from your Terraform configuration after it has been applied. This is useful for retrieving IP addresses, resource IDs, or any other relevant data.

#### Defining Outputs in `outputs.tf`

You can define outputs in a separate `outputs.tf` file within your Terraform configuration directory. Below is an example of defining an output named `vm_ip` that captures the private IP address of a virtual machine:

```hcl
output "vm_ip" {
  description = "The private IP address of the virtual machine"
  value       = azurerm_virtual_machine.example.private_ip_address
}
```

In the example above, the `value` attribute of the `output` block references the `private_ip_address` attribute of an `azurerm_virtual_machine` resource named `example`.

#### Viewing Outputs with `terraform output`

After applying your Terraform configuration, you can view the defined outputs using the `terraform output` command. This will display the values of all defined outputs, making it easy to retrieve important information about your infrastructure:

```bash
terraform output
```

The `terraform output` command will display the output in the terminal as follows:

```plaintext
vm_ip = "10.0.0.4"
```

By utilizing outputs in your Terraform configurations, you can easily extract and display important information about your infrastructure, making it easier to manage and monitor your resources after they have been provisioned.

### Data Sources

Data sources allow you to fetch information from external sources or existing infrastructure. This can be useful for retrieving information about existing resources to be used in your configurations.

#### Using Data Sources to Retrieve Secrets from Azure Key Vault

One common scenario for using data sources in Terraform is to retrieve secrets stored in an Azure Key Vault. Below is an example that demonstrates how to use the `azurerm_key_vault_secret` data source to fetch a secret from an Azure Key Vault and use it in your Terraform configuration:

```hcl
data "azurerm_key_vault_secret" "example_secret" {
  name         = "my-secret"
  key_vault_id = "/subscriptions/subscription_id/resourceGroups/my-resource-group/providers/Microsoft.KeyVault/vaults/my-key-vault"
}

resource "azurerm_virtual_machine" "example" {
  name                = "example-vm"
  location            = "eastus"
  resource_group_name = "my-resource-group"

  admin_username      = "adminuser"
  admin_password      = data.azurerm_key_vault_secret.example_secret.value
}
```

In the example above:

- The `azurerm_key_vault_secret` data source is used to fetch the secret named `my-secret` from an Azure Key Vault.
- The `value` attribute of the `azurerm_key_vault_secret.example_secret` data source is used as the `admin_password` for an `azurerm_virtual_machine` resource.

By leveraging data sources in your Terraform configurations, you can easily fetch information from external sources or existing infrastructure, enabling you to use that information to configure and provision resources in a more dynamic and flexible manner.

### Local Values

Local values allow you to define intermediate values that can be reused within your Terraform configuration files. They are useful for avoiding repetition and improving readability.

#### Using Local Values to Set Region Code Based on Full Region Name in `azurerm`

An example scenario for using local values in Terraform is to set the region code based on the full region name for use with `azurerm`. Below is an example that demonstrates how to use local values to map full region names to their corresponding region codes:

```hcl
locals {
  region_mapping = {
    "East US"      = "eastus"
    "West US"      = "westus"
    "Central US"   = "centralus"
    "East Asia"    = "eastasia"
    "Southeast Asia" = "southeastasia"
    # Add more region mappings as needed
  }
}

resource "azurerm_virtual_machine" "example" {
  name                = "example-vm"
  location            = local.region_mapping["East US"]
  resource_group_name = "my-resource-group"

  admin_username      = "adminuser"
  admin_password      = "AdminPassword123!"
}
```

In the example above:

- The `locals` block defines a `region_mapping` map that maps full region names to their corresponding region codes.
- The `location` attribute of the `azurerm_virtual_machine.example` resource uses the `local.region_mapping["East US"]` local value to set the region code for the virtual machine to "eastus".

By leveraging local values in your Terraform configurations, you can define intermediate values that can be reused throughout your configuration files, making it easier to manage and maintain your infrastructure code.

### Expressions

Terraform supports a wide range of expressions for manipulating and referencing values within your configurations, such as arithmetic operations, string manipulation, and more.

```hcl
resource "libvirt_domain" "example" {
  name   = "vm-${count.index}"
  memory = var.memory
  vcpu   = "1"
}
```

### Functions

Terraform provides built-in functions for string manipulation, mathematical operations, and more. These functions can be used within your configurations to generate or transform values.

```hcl
output "vm_names" {
  value = join(",", libvirt_domain.example.*.name)
}
```

### Provisioners

Provisioners allow you to run scripts or commands on a resource after it has been created or destroyed. This can be useful for tasks such as installing software or configuring services.

```hcl
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
```

### terraform.tfvars

The `terraform.tfvars` file allows you to set values for your variables, making it easier to manage and share configuration settings. You can have multiple `tfvars` files to manage workspace-specific configurations. Below is an example demonstrating how to have multiple `tfvars` per workspace:

Example of "dev.tfvars" file for development workspace.

```hcl
environment   = "dev"
instance_type = "t2.micro"
```

Example of "prod.tfvars" file for production workspace.

```hcl
environment   = "prod"
instance_type = "t2.large"
```

#### Using "terraform.tfvars" in workspace

Load workspace-specific variables:

```hcl
locals {
  workspace_vars = try(file("${path.module}/${terraform.workspace}.tfvars"), {})
}
```

Set common variables:

```hcl
region     = "us-west-1"
dns_domain = "example.com"
```

Set workspace-specific variables:

```hcl
environment   = local.workspace_vars.environment
instance_type = local.workspace_vars.instance_type
```

### Modules

Modules enable code reusability and allow you to organize your Terraform configurations into reusable components. They can be used to encapsulate and abstract complex configurations.

#### Example Module: `instance`

Here is an example of a Terraform module named `instance` that provisions a virtual machine:

```hcl
# modules/instance/main.tf

variable "name" {
  description = "Name of the virtual machine"
  type        = string
}

variable "instance_type" {
  description = "Type of the virtual machine instance"
  type        = string
  default     = "t2.micro"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type
  tags = {
    Name = var.name
  }
}
```

You can use the instance module in your main Terraform configuration file as follows:

```hcl

# main.tf

module "dev_instance" {
  source       = "./modules/instance"
  name         = "dev-instance"
  instance_type = "t2.micro"
}

module "prod_instance" {
  source       = "./modules/instance"
  name         = "prod-instance"
  instance_type = "t2.large"
}
```

Module names must be unique within your Terraform configurations to avoid conflicts. Ensure that each module has a distinct name when you include it multiple times in your configurations.

By utilizing modules in your Terraform configurations, you can improve code organization, promote code reuse, and manage complex infrastructures more efficiently.

### Cloud-Init

Cloud-Init is a widely used approach to initialize cloud instances with user data. It's commonly used with virtual machines to automate the configuration process.

```hcl
resource "libvirt_cloudinit_disk" "example" {
  name    = "cloud-init-disk"
  user_data = file("cloudinit.cfg")
}
```

### Network Configuration

You can define network configurations to manage the networking settings of your virtual machines.

```hcl
resource "libvirt_network" "example" {
  name = "terraform-network"
  mode = "nat"
  xml_config = file("network_config.cfg")
}
```

### Provider and Module Installation

Before you can use a provider or module in your Terraform configuration, you need to install it. Terraform uses the `terraform init` command to initialize a working directory containing Terraform configuration files. This command downloads the necessary providers and modules specified in your configuration files.

#### Installing Providers

To install a specific provider, you can specify it in your Terraform configuration file using the `required_providers` block or by directly referencing it in your resources.

Here is an example of specifying the `aws` provider in your configuration:

```hcl

provider "aws" {
  region = "us-west-1"
}
```

After adding the provider configuration, run the following command to initialize your Terraform working directory:

```bash
terraform init
```

#### Installing Modules

To use a module in your Terraform configuration, you can specify its source in your configuration file using the module block.
Here is an example of using a module named example-module:

```hcl

module "example_module" {
  source = "github.com/example/example-module"
}
```

After adding the module configuration, run the following command to initialize your Terraform working directory:

```bash
terraform init
```

#### Updateing Providers and Modules

To update to the latest versions of the providers and modules, you can use the terraform init -upgrade command. This command updates the provider and module dependencies to the latest compatible versions.

Run the following command to upgrade the providers and modules in your Terraform working directory:

```bash
terraform init -upgrade
```

### Workspaces

Workspaces allow you to manage multiple environments (e.g., development, staging, production) within a single Terraform configuration.

```bash
terraform workspace new dev
terraform workspace select dev
```

### State Management Commands

Terraform provides commands to manage the state file, which tracks the current state of your infrastructure managed by Terraform. You can use the following commands to interact with the state file:

#### List Resources in State File

The `terraform state list` command displays a list of all resources that are currently being managed by Terraform.

```bash
terraform state list
```

#### Show Resource Details

The terraform state show command displays detailed information about a specific resource in the state file.

```bash
terraform state show aws_instance.example
```

#### Remove Resource from State File

The terraform state rm command removes a resource from the state file. Use this command with caution, as it will not destroy the actual resource, but only remove it from the state file.

```bash
terraform state rm aws_instance.example
```

#### Pull Current State

The terraform state pull command fetches the current state from the backend and writes it to a file.

```bash
terraform state pull > terraform.tfstate
```

#### Push Local State to Backend

The terraform state push command uploads the local state file to the backend.

```bash
terraform state push
```

By utilizing these state management commands, you can inspect, modify, and sync the state file to manage your infrastructure effectively with Terraform.

### Locking

State file locking prevents concurrent runs that can lead to conflicts and inconsistencies in the infrastructure.

```hcl
terraform {
  lock {
    enabled = true
  }
}
```

### Sensitive Data

You can mark sensitive variables to prevent them from being displayed in the console output or stored in the state file.

```hcl
variable "password" {
  description = "The database password"
  sensitive   = true
}
```

---

## Installation

To install Terraform, download the appropriate package for your operating system from the [official Terraform website](https://www.terraform.io/downloads.html) and follow the installation instructions.

### For Windows

#### Windows AMD64 binary

Link: <https://releases.hashicorp.com/terraform/1.7.5/terraform_1.7.5_windows_amd64.zip>

#### Windows 386 binary

Link: <https://releases.hashicorp.com/terraform/1.7.5/terraform_1.7.5_windows_386.zip>

### For macOS

#### Package manager

```bash
 brew tap hashicorp/tap
 brew install hashicorp/tap/terraform
```

#### Binary AMD64

LINK: <https://releases.hashicorp.com/terraform/1.7.5/terraform_1.7.5_darwin_amd64.zip>

#### Binary ARM64

LINK: <https://releases.hashicorp.com/terraform/1.7.5/terraform_1.7.5_darwin_arm64.zip>

### For Ubuntu

```bash
 wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
 echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
 sudo apt update && sudo apt install terraform
```

### For CentOS/RHEL

```bash
 sudo yum install -y yum-utils
 sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
 sudo yum -y install terraform
```

### For Fedora

```bash
 sudo dnf install -y dnf-plugins-core
 sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
 sudo dnf -y install terraform
```

### for Amazon Linux

```bash
 sudo yum install -y yum-utils shadow-utils
 sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
 sudo yum -y install terraform
```

---

By adopting Terraform and Infrastructure as Code practices, organizations can achieve improved agility, scalability, and consistency in managing their infrastructure, leading to faster development cycles, reduced costs, and increased operational efficiency.
