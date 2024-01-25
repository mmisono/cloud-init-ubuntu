
img := "jammy-server-cloudimg-amd64.img"
img_url := "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
vm_img := "vm.qcow2"
cloud_init_img := "cloud-init.img"

run:
    qemu-system-x86_64 \
      -m 2048 \
      -smp 2 \
      -nic user,model=virtio \
      -drive file={{vm_img}},format=qcow2,if=virtio \
      -nographic \
      -machine type=pc,accel=kvm \
      -cpu host

install:
    qemu-system-x86_64 \
      -m 2048 \
      -smp 2 \
      -nic user,model=virtio \
      -drive file={{vm_img}},format=qcow2,if=virtio \
      -drive file={{cloud_init_img}},format=raw,if=virtio \
      -nographic \
      -machine type=pc,accel=kvm \
      -cpu host

get-img:
    wget {{img_url}}
    md5sum {{img}}

create-img:
    qemu-img create -b {{img}} -F qcow2 -f qcow2 {{vm_img}} 20G
    cloud-localds {{cloud_init_img}} user-data meta-data

