
# DEMO

---

## Purpose of the demo

The purpose of this demo is to showcase the setup of Virtual Machines (VMs)
using Terraform in conjunction with the libvirt/KVM hypervisor. This
demonstration aims to provide a practical application of the theoretical
knowledge about infrastructure as code (IaC) and virtualization.

## Application from Theory

From the theory part, we'll be applying the following:
    - Infrastructure as Code (IaC) principles
    - Usage of Terraform for provisioning and managing infrastructure
    - Virtualization concepts using libvirt/KVM

## Expected Learning/Outcome

By the end of this demo, you should be able to:
    - Set up virtual machines using Terraform and libvirt/KVM
    - Understand how to configure VMs with different specifications
    - Create a `hosts` file for Ansible to manage the provisioned VMs

## What the demo entails?

Setting up via terraform Virtual Machines using the libvirt/KVM hypervisor.

### Requirements

- Provision a specific number of VM instances
- Configure each instance with different specifications
- Generate a `hosts` file for Ansible to manage the VMs

## Prerequisites

Before diving into the demo, let's set the stage. To create and manage Virtual
Machines (VMs), we need a hypervisor. The go-to hypervisor for Linux is KVM,
and that's what we'll be using in this demo.

### Installing Virtualization (KVM Libvirt)

First things first, let's install KVM to enable virtualization on your machine.
If you haven't done this already, please follow the steps below to install KVM
on Ubuntu 22.04:

1. **Update Package List**

    ```bash
    sudo apt update
    ```

2. **Install KVM and Related Packages**

    ```bash
    sudo apt install -y qemu qemu-kvm libvirt-daemon libvirt-clients bridge-utils
    ```

3. **Enable and Start libvirtd Service**

    ```bash
    sudo systemctl enable --now libvirtd
    ```

4. **Check if KVM Kernel Modules are Loaded**

    ```bash
    lsmod | grep kvm
    ```

*Note:* After you have libvirt/kvm hypervisor installed on your system, it's
essential to disable SELinux or AppArmor if they are enabled to avoid conflicts
with libvirt. To disable it just edit the /etc/libvirt/qemu.conf file and set
the 'security_driver = "none"' (also uncomment the line if is commented).
After security driver is set to none you can restart the libvirt service for
changes to take effect, you can use below command to achieve this:

```bash
 sudo systemctl restart libvirtd
```

### Download Ubuntu image for VMs

Now we are in the position that we have a hypervisor installed on our system
and wanna create some virtual machines using it. Those virtual machines are
hungry for an operating system, so that we can actually operate them. In that
purpose we will need to download the image of that operating system which will
be an Ubuntu 22.04 image for this demo.

I will leave a link below from where you can find some Ubuntu images:
<https://cloud-images.ubuntu.com/jammy/current/>.

*Note* I suggest using the KVM-optimised kernel one
(<https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64-disk-kvm.img>).
You can run the command below to get it:

```bash
wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64-disk-kvm.img
```

After you have the .img file in your local machine, we will need to simply
extend that image with at least 10GB using QEMU. Use the command below for that.

```bash
qemu-img resize path/to/jammy-server-cloudimg-amd64-disk-kvm.img +10G
```

## How to run the demo?

Once you've completed the prerequisites, you're all set to proceed with running
the demo. Follow the steps below to execute the demonstration:

1. **Create Directory and Navigate to the Directory**

    ```bash
    mkdir terraform-demo
    cd terraform-demo
    ```

2. **Clone GitHub Repository**

    ```bash
    git clone https://github.com/Digital-Anthropic/cloud-labs
    ```

3. **Navigate to the demo directory**

    ```bash
    cd cloud-labs/terraform/demos
    ```

    *Note* After you have the demo files locally you will need to change
    terraform.tfvars file to fit you(CPU, RAM, SOURCE).

4. **Initialize Terraform**

    ```bash
    terraform init
    ```

5. **Preview the plan that Terraform created**

    ```bash
    terraform plan
    ```

6. **Apply the plan**

    ```bash
    terraform apply
    ```

By following these steps, you'll provision VMs with the specified configurations
using Terraform and libvirt/KVM.
