# Terraform and Infrastructure as Code (IAC) Documentation

## Introduction

Terraform is an open-source Infrastructure as Code (IAC) tool created by
HashiCorp.

It allows you to define and provision infrastructure using a declarative
configuration language.

This documentation provides an overview of Terraform, its components,
the benefits of adopting Infrastructure as Code practices and also how to
get started with the code provided.

In essence, Terraform acts as a reconciler between the current state of
infrastructure(kept in tf state, usually in the cloud) and the desired
infrastructure(terraform configuration files).

Planning shows you the required actions to move from current state to
desired state and Apply actually performs these changes.

## Table of Contents

Add to advanced:
- tf import
- moved {to from} aka refactoring
- depends on
- lifecycle {ingnore_changes, etc}

Make sure this table is up to date!

Make all code examples respect the coding standards written down

use set colorcolumn=80

instead of putting <enter> aka new paragraph you can use "  " aka two spaces
at end of line to write just under it.

use :set list and check terraform init example, it looks really bad in the
parsed markdown


1. [Infrastructure as Code (IAC)](#infrastructure-as-code-iac)
    - [Benefits of IAC](#benefits-of-iac)
2. [Terraform Overview](#terraform-overview)
    - [State Management](#state-management)
    - [Generic Terraform Workflow](#generic-terraform-workflow)
    - [Terraform Context](#terraform-context)
    - [Terraform Coding Guidelines](#terraform-coding-guidelines)
3. [Terraform Basics](#terraform-basics)
    - [Resources](#resources)
    - [Providers](#providers)
    - [Variables](#variables)
    - [Outputs](#outputs)
    - [Sensitive Data](#sensitive-data)
    - [Data Sources](#data-sources)
    - [Local Values](#local-values)
    - [Basic Expressions](#basic-expressions)
    - [terraform.tfvars](#terraformtfvars)
    - [Modules](#modules)
    - [Provider and Module Installation](#provider-and-module-installation)
    - [Workspaces](#workspaces)
    - [State Management Commands](#state-management-commands)
    - [Locking](#locking)
4. [Terraform Advanced](#terraform-advanced)
    - [Advanced Expressions](#advanced-expressions)
    - [Provisioners](#provisioners)
    - [Multi-Cloud Support](#multi-cloud-support)
5. [Installation](#installation)

## Infrastructure as Code (IaC)

Managing cloud infrastructure without Infrastructure as Code (IaC) leads
to challenges such as:
- inconsistency across environments
- human errors
- scalability issues
- no automation

Terraform serves as a powerful example of IaC, automating infrastructure
provisioning and management by allowing you to define your infrastructure
in configuration files.

This approach addresses the pain points associated with manual infrastructure
management.

### Benefits of IAC

#### Version Control

- **Code Repositories**: Store infrastructure code in version control systems
like Git, enabling versioning, history tracking, and collaboration.
- **Code Reviews**: Implement code review practices to ensure quality,
security, and compliance of infrastructure code changes.

#### Consistency, Reproducibility and Rollbacks

- **Consistent Deployments**: Ensure consistent and repeatable infrastructure
- **Environment Parity**: Bring developers/qa closer to production environment
- **Reusable Components**: Create reusable infrastructure code modules and
templates that improve productivity and standardization
- **Reproducibility**: Can do rollbacks

##### Importance of Reproducibility and Rollbacks

Before IaC, managing rollbacks was hard and error-prone.
It was challenging to keep track of the tiny bits and pieces that were changed
manually, making it difficult to revert to a previous state reliably.

With IaC, you can leverage version control systems like Git to track
changes to your infrastructure configurations over time. This enables you to:

- Easily roll back to previous versions of your infrastructure configurations.
- Reproduce specific infrastructure states for debugging, testing, or auditing
purposes.

#### Scaling

- **Efficient Scaling**: Easier scaling of infrastructure resources to handle
increased workload demands, improving customer satisfaction

#### Collaboration and Knowledge Sharing

- **Shared Understanding**: Facilitate collaboration across ops teams.
No single point of failure(human)

---

## Terraform Overview

### State Management

Terraform maintains a consistent state of your infrastructure by tracking
changes and dependencies between resources.

The `tfstate` file stores the current state of your infrastructure,
allowing Terraform to understand which resources need to be created,
updated, or destroyed.

#### Best Practices for State Management

- **Secure Storage**: Ensure the `tfstate` file is stored securely to protect
sensitive information. Avoid storing it in public repositories.
- **Collaboration**: For team-based projects, storing the state file in a
shared location ensures that all team members are working with the
same infrastructure.
- **Backup**: Regularly backup the state file to prevent data loss in case
of accidental deletion or corruption.

#### Storing Terraform State in Azure Storage Account

To store the Terraform state file in an Azure Storage Account,
you can use the following backend configuration:

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

For more information on configuring Azure Storage as a Terraform backend,
refer to the [AzureRM Backend Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/backend).

#### Storing Terraform State in AWS S3 Bucket

To store the Terraform state file in an AWS S3 Bucket, you can use the
following backend configuration:

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

For more information on configuring AWS S3 as a Terraform backend, refer to the
[AWS S3 Backend Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/backends/s3).

### State Management Commands

Terraform provides commands to manage the state file, which tracks the current
state of your infrastructure managed by Terraform.

You can use the following commands to interact with the state file:

#### List Resources in State File

The `terraform state list` command displays a list of all resources that are
currently being managed by Terraform.

```bash
terraform state list
```

#### Show Resource Details

The terraform state show command displays detailed information about a
specific resource in the state file.

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

By utilizing these state management commands, you can inspect, modify, and sync the state file to manage your infrastructure.

### Locking

State file locking in Terraform prevents concurrent runs that can lead to conflicts and inconsistencies in the infrastructure.
It ensures that only one Terraform client can modify the state at a time.

```hcl
terraform {
  lock {
    enabled = true
  }
}
```

#### Default Behavior

The default behavior for state file locking in Terraform is to lock the state file automatically when performing operations like `terraform apply` or `terraform plan`.

#### Behavior During Forceful Shutdown

When a `terraform apply` or `terraform plan` operation is forcefully shut down (e.g., by using `Ctrl+C`), the state file remains locked for a certain period to prevent concurrent modifications.
The duration of this lock can be configured using the `-lock-timeout` flag.

#### Unlocking the State File

If for some reason the state file remains locked and you need to unlock it manually, you can use the following command:

```bash
terraform force-unlock LOCK_ID
```

### Generic Terraform Workflow

Terraform provides a series of commands to manage and apply your infrastructure configurations in a systematic manner.

- terraform init
- terraform validate
- terraform plan -out this.plan
- terraform apply this.plan

#### Initialize Terraform Workspace `terraform init`

Before applying any Terraform configurations, it's essential to initialize the Terraform workspace.  
This step downloads the required provider plugins and initializes the backend and installs any required modules.  
It is also required to upgrade providers and modules.

#### Validate Terraform code `terraform validate`

A good practice, before running plan is to run validate.

Validate does not query any remote services.
It just ensures syntactic consistency of providers and modules.

It enables you to catch quick easy bugs without the lengthy process of plan

#### Plan Infrastructure Changes `terraform plan`

Planning will actually go and query the remote services and compare them with the current known state.

It is by far the most time consuming terraform operation(excluding the creation of whole infra from scratch).

It generates for us the changes required to move from the state to the desired state.

It won't perform any infra changes.

The `-out` flag allows you to save the generated plan to a file named `plan`, which can be used later with `terraform apply`.

#### Apply Infrastructure Changes with `terraform apply`

After reviewing the execution plan and ensuring everything looks correct, you can apply the changes to your infrastructure using the `terraform apply` command.
This command reads the saved plan from the `plan` file and applies the changes to provision or update your infrastructure accordingly.

By following this `plan` and `apply` workflow, you can preview and apply changes to your infrastructure.

### Terraform Context

Which files does Terraform know to include? or discard when running the above commands?

They made it simple for us.
Everything ending in .tf in the current working directory is lumped togheter and interpreted at once.

This makes it rather easy to organize tf code likewise:

```
main.tf      # bulk of the resources
variables.tf # think of these as function inputs for your tf code
locals.tf    # these would be variables declared in the function context
data.tf      # when we want to query remote services
output.tf    # return variables
```

This is a generic example that is popular in the industry.
There are multiple ways on how to organize code, no one size fits all.

Key take away is terraform merges `./*.tf` files togheter and interprets them at once.

### Terraform Coding Guidelines

Tabs as 2 spaces.

Example module instantiation:

```hcl
module "network" {
  source = "path/to/source" # the source definition always sits at the very top so we know what we run

  for_each/count = var.networks # loops are second

  parameter1       = value1 # parameters are third
  parameterlonger2 = value2 # when we have a block of parameters we alliniate = for readability
  ...
  parametern       = valuen

  blocks_come_next { # blocks next
    block_parameter1 = value1
    block_parameter2 = value2
  }

  lifecycle { # lifecycle tag is the last but one
    ignore_changes = []
  }

  depends_on = [] # depends on[building dependency between modules/resources] is the last one
}
```

---

## Terraform Basics

### Resources

Resources are the building blocks of your infrastructure. They define the desired state of a particular object, such as a virtual machine, network, or DNS record.

```hcl
resource "libvirt_domain" "example" {
  name   = "terraform-vm"
  memory = "512"
  vcpu   = "1"
}
```

### Providers

Providers are responsible for managing the lifecycle of a resource: create, read, update, delete. They determine how to communicate with the respective APIs and perform CRUD operations.

```hcl
provider "libvirt" {
  uri = "qemu:///system"
}
```

### Variables

#### Defining Variables in `variables.tf`

You can define variables in a separate `variables.tf` file within your Terraform configuration directory. Below is an example of defining a variable named `location`:

```hcl
variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "eastus"
}
```

#### Defining Variables with Default Types

You can constrain variables to default types in HCL (HashiCorp Configuration Language) such as `string`, `number`, `bool`, `list`, `map`, etc.

#### Example of Location Variable

```hcl
variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "eastus"
}
```

#### Example of Virtual Machine Configuration Object

```hcl
variable "vm_config" {
  description = "Virtual machine configuration"
  type        = object({
    name     = string
    size     = string
    os_disk  = map(string)
    data_disks = list(map(string))
  })
  default = {
    name     = "my-vm"
    size     = "Standard_DS1_v2"
    os_disk  = {
      storage_account_type = "Premium_LRS"
      disk_size_gb         = "128"
    }
    data_disks = [
      {
        storage_account_type = "Premium_LRS"
        disk_size_gb         = "128"
      },
      {
        storage_account_type = "Premium_LRS"
        disk_size_gb         = "256"
      }
    ]
  }
}
```

#### Common Variable Types

- **String**: `type = string`
- **Map**: `type = map(string)`
- **List**: `type = list(string)`
- **Map of Maps**: `type = map(map(string))`
- **Object**:
```hcl
type = list(object({
  create     = bool
  name       = string
  properties = map(string)
}))
```

Object allows us to bind together different types in a logical component.

#### Validating Variables

Validating variables is crucial to ensure that the provided values meet certain criteria or constraints. You can use the `validation` block to enforce validation rules on variables.

Example: Validating VM Size

```hcl
variable "vm_size" {
  description = "Virtual machine size"
  type        = string

  validation {
    condition     = length(var.vm_size) > 0
    error_message = "The VM size must not be empty."
  }
}
```

#### Why Validating Variables is Important

- **Data Integrity**: Ensures that the data provided for variables is valid and consistent.
- **Error Prevention**: Helps prevent misconfigurations and potential issues during resource provisioning.
- **Improved Debugging**: Provides clear error messages when validation rules are not met, aiding in troubleshooting.

By leveraging Terraform's variable capabilities, including type constraints, object construction, and validation, you can create more robust, flexible, and maintainable infrastructure as code configurations.

#### Using Variables in Resources

Once a variable is defined, you can reference it within resources using the `${var.variable_name}` syntax. Here's an example that demonstrates how to use the `location` variable in an `azurerm_resource_group` resource:

variables.tf
```hcl 
variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "eastus"
}
```

main.tf
```hcl
resource "azurerm_resource_group" "example_rg" {
  name     = "example-resource-group"
  location = var.location
}
```

In the above example, we parameterized the location by using variables.

### Outputs

Outputs allow you to extract and display information from your Terraform configuration after it has been applied.
This is useful for retrieving IP addresses, resource IDs, or any other relevant data.
Outputs are most useful for chaining modules together.
By using outputs from one module as inputs to another, you can create a modular infrastructure configuration, enhancing reusability and maintainability.

#### Defining Outputs in `outputs.tf`

You can define outputs in a separate `outputs.tf` file within your Terraform configuration directory. Below is an example of defining an output named `vm_ip` that captures the private IP address of a virtual machine:

outputs.tf
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

By utilizing outputs in your Terraform configurations, you can easily extract and display important information about your infrastructure.

We will see in the Modules section how to chain modules togheter.

### Data Sources

Data sources allow you to fetch information from external sources or existing infrastructure.
This can be useful for retrieving information about existing resources to be used in your configurations.

#### Using Data Sources to Retrieve Secrets from Azure Key Vault

One common scenario for using data sources in Terraform is to retrieve secrets stored in an Azure Key Vault.
Below is an example that demonstrates how to use the `azurerm_key_vault_secret` data source to fetch a secret from an Azure Key Vault and use it in your Terraform configuration:

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

### Local Values

Local values allow you to define intermediate values that can be reused within your Terraform configuration files. They are useful for avoiding repetition and improving readability.

#### Using Local Values to Set Region Code Based on Full Region Name in `azurerm`

An example scenario for using local values in Terraform is to set the region code based on the full region name for use with `azurerm`. Below is an example that demonstrates how to use local values to map full region names to their corresponding region codes:

```hcl
variable "location" {
  description = "Azure Location to use"
  type        = string
  default     = "East US"
}

locals {
  region_mapping = {
    "East US"        = "eastus"
    "West US"        = "westus"
    "Central US"     = "centralus"
    "East Asia"      = "eastasia"
    "Southeast Asia" = "southeastasia"
    # Add more region mappings as needed
  }

  region_code = local.region_mapping[var.location]
}

resource "azurerm_virtual_machine" "example" {
  name                = "example-vm"
  location            = local.region_code
  resource_group_name = "my-resource-group"

  admin_username      = "adminuser"
  admin_password      = "SuperSecurePassword;)"
}
```

In the example above:

- The `locals` block defines a `region_mapping` map that maps full region names to their corresponding region codes.
- The `location` attribute of the `azurerm_virtual_machine.example` resource uses the `local.region_mapping["East US"]` local value to set the region code for the virtual machine to "eastus".

### Basic Expressions

#### Arithmetic Operations

You can perform basic arithmetic operations in Terraform using expressions.

```hcl
variable "memory" {
  description = "The memory size for the VM in MB"
  type        = number
  default     = 1024
}

resource "libvirt_domain" "example" {
  name   = "vm-${count.index}"
  memory = var.memory * 2  # Doubles the memory size
  vcpu   = "1"
}
```

#### String Manipulation

String manipulation functions allow you to modify and concatenate strings.

```hcl
resource "libvirt_domain" "example" {
  name   = "vm-${count.index}"
  memory = var.memory
  vcpu   = "1"
  hostname = "vm-${count.index}.example.com"  # Concatenates strings
}
```

### Conditional Expressions

Terraform supports conditional expressions to handle conditional logic within your configurations.

```hcl
resource "libvirt_domain" "example" {
  count = azurerm_vms(list)

  name   = "vm-${count.index}"
  memory = var.memory
  vcpu   = "1"
  enabled = count.index % 2 == 0  # Enables every other VM
}
```

### Advanced Expressions

#### List Functions

You can use list functions to manipulate and iterate over lists.

```hcl
variable "disk_sizes" {
  description = "List of disk sizes in GB"
  type        = list(number)
  default     = [128, 256, 512]
}

resource "libvirt_domain" "example" {
  name   = "vm-${count.index}"
  memory = var.memory
  vcpu   = "1"
  disk_size_gb = var.disk_sizes[count.index % length(var.disk_sizes)]
}
```

#### Map Functions

Map functions allow you to manipulate and iterate over maps.

```hcl
variable "networks" {
  description = "Map of network configurations"
  type        = map(object({
    cidr_block = string
    gateway    = string
  }))
  default = {
    internal = {
      cidr_block = "10.0.1.0/24"
      gateway    = "10.0.1.1"
    },
    external = {
      cidr_block = "192.168.1.0/24"
      gateway    = "192.168.1.1"
    }
  }
}

resource "libvirt_domain" "example" {
  name   = "vm-${count.index}"
  memory = var.memory
  vcpu   = "1"
  network_config = var.networks[count.index % length(var.networks)]
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

### Modules

Modules enable code reusability and allow you to organize your Terraform configurations into reusable components. They can be used to encapsulate and abstract complex configurations.

#### Associating Modules with Functions

When thinking about Terraform modules, you can associate them with functions in programming:

- **Input** in functions corresponds to **variables** in Terraform modules.
- **Output** in functions corresponds to **returns** in Terraform modules.

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

### CLI Workspaces

Workspaces allow you to manage multiple environments (e.g., development, staging, production) within a single Terraform configuration.

```bash
terraform workspace new dev
terraform workspace select dev
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

### Multi-Cloud Support

Terraform supports provisioning and managing resources across multiple cloud providers and on-premises environments using a single tool.

#### Using Multiple `azurerm` Providers with Resources

You can specify multiple `azurerm` providers in your Terraform configuration to manage resources across different Azure subscriptions.
Below is an example that demonstrates how to use two `azurerm` providers to create resources in two different Azure Resource Groups (RGs):

```hcl
provider "azurerm" {
  alias   = "subscription1"
  features {}
}

provider "azurerm" {
  alias   = "subscription2"
  features {}
}

resource "azurerm_resource_group" "example" {
  provider             = azurerm.subscription1
  name                 = "example-resources-subscription1"
}

resource "azurerm_resource_group" "example_subscription2" {
  provider             = azurerm.subscription2
  name                 = "example-resources-subscription2"
}
```

#### Using `azurerm` and `aws` Providers with Resources

You can also use both `azurerm` and `aws` providers in the same Terraform configuration. Below is an example that demonstrates how to use one `aws` provider and two `azurerm` providers to manage resources across AWS and Azure:

```hcl
provider "azurerm" {
  features {}
}

provider "aws" {
}

resource "azurerm_resource_group" "example" {
  provider = azurerm
  name     = "example-resources"
}

resource "aws_s3_bucket" "example" {
  provider = aws
  bucket   = "my-example-bucket"
  acl      = "private"
}
```

#### Specifying Providers in Resources

When using multiple providers, you can specify which provider to use for each resource using the `provider` attribute.

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

### Organizing full project

Organizing your Terraform code into a structured folder and project layout can help maintainability and readability. Here's a recommended folder structure:

```css
terraform-project/
├── main.tf
├── variables.tf
├── outputs.tf
├── modules/
│   ├── s3_bucket/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── ...
├── env/
│   ├── dev.tfvars 
│   └── prod.tfvars
└── ...

```

### terraform.tfvars

The `terraform.tfvars` file allows you to set values for your variables, making it easier to manage and share configuration settings.
You can have multiple `tfvars` files to manage workspace-specific configurations. Below is an example demonstrating how to have multiple `tfvars` per workspace:

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

*Note* Variable Loading

It's important to note that when you initiate Terraform (terraform init), it does not load workspace-specific tfvars files automatically. You need to specify the variable file using the -var-file flag when running terraform plan, terraform apply, or terraform validate.

To specify a workspace-specific tfvars file, you can use the -var-file flag as follows:

```bash
terraform plan -var-file=env/dev.tfvars
```

This will load the variables from env/dev.tfvars and use them in your Terraform operations.


### Conditionals in Terraform

You can use conditionals in Terraform to control resource creation based on certain conditions. The syntax for conditionals is as follows:

```hcl
resource "aws_instance" "example" {
  count = var.create_instance ? 1 : 0
}
```

### Loops in Terraform

#### Using count with Lists

You can use the count parameter to create multiple instances of a resource based on a list:

```hcl
variable "instance_names" {
  type    = list(string)
  default = ["instance1", "instance2"]
}

resource "aws_instance" "example" {
  count = length(var.instance_names)

  tags = {
    Name = var.instance_names[count.index]
  }
}
```

#### Using for_each with Maps

You can use the for_each parameter to create multiple instances of a resource based on a map:

```hcl
variable "instance_map" {
  type = map(string)
  default = {
    instance1 = "ami-12345678"
    instance2 = "ami-87654321"
  }
}

resource "aws_instance" "example" {
  for_each = var.instance_map

  ami           = each.value
  instance_type = "t2.micro"

  tags = {
    Name = each.key
  }
}
```

### Dynamic Blocks in Terraform

Dynamic blocks in Terraform allow you to include multiple configurations within a single resource block based on certain conditions or variables.

```hcl
resource "azurerm_linux_function_app" "example" {
  name                       = "example-function-app"
  location                   = "West Europe"
  resource_group_name        = azurerm_resource_group.example.name
  app_service_plan_id        = azurerm_app_service_plan.example.id
  storage_account_name       = azurerm_storage_account.example.name
  storage_account_access_key = azurerm_storage_account.example.primary_access_key

  dynamic "site_config" {
    for_each = var.is_linux ? [1] : []
    content {
      linux_fx_version = "DOCKER|nginx:latest"
    }
  }
}
```

By adopting Terraform and Infrastructure as Code practices, organizations can achieve improved agility, scalability, and consistency in managing infrastructure.
