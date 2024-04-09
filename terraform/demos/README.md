# Getting started with demo files

---

## Terraform Steps

1. **Installing virtualization(KVM Libvirt)**:
    For us to get started we will need to have virtualization enabled on our host machine. Check this link below and follow the steps to install kvm on your machine.
    <https://www.linuxtechi.com/how-to-install-kvm-on-ubuntu-22-04/>

2. **Add provider dmacvicar/libvirt to terraform**:
    In order to get started with our terraform project we will need the provider, dmacvicar/libvirt in our case. Follow the steps below to achieve this goal. Note that you will have to adjust the version(0.7.6) and os_architecture(linux_amd64) to fit your specs and requirements.

    ```bash
    mkdir -p ~/.local/share/terraform/plugins/registry.terraform.io/dmacvicar/libvirt/0.7.6/linux_amd64
    cd ~/.local/share/terraform/plugins/registry.terraform.io/dmacvicar/libvirt/0.7.6/linux_amd64
    ```

    After creating those directories we will need to download the release zip file of the version/architecture needed. Take a look at the link below and change the wget command to fit you.
    <https://github.com/dmacvicar/terraform-provider-libvirt/releases>

    ```bash
    wget <https://github.com/dmacvicar/terraform-provider-libvirt/releases/download/v0.7.6/terraform-provider-libvirt_0.7.6_linux_amd64.zip>
    ```

    When the download is finished you will have a zip file in your directory. Yes, we need to unzip it. C&P the below command to unzip the file. NOTE: You can remove the zip file after extraction.

    ```bash
    unzip terraform-provider-libvirt_0.7.6_linux_amd64.zip
    ```

3. **Download Ubuntu image for VMs**:
    To install Ubuntu on our virtual machines we will need the OS image. I will leave a link below from where you can find some Ubuntu images:
    <https://cloud-images.ubuntu.com/jammy/current/>.

    ###########I suggest using the KVM-optimised kernel one(<https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64-disk-kvm.img>).

    After you have the .img file in your local machine, we will need to simply extend that image with at least 10GB using QEMU. Use the command below to do that.

    ```bash
    qemu-img resize path/to/jammy-server-cloudimg-amd64-disk-kvm.img +10G
    ```
