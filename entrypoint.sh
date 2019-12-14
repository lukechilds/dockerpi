#!/bin/sh

image_path="/data/filesystem.img"
zip_path="/filesystem.zip"

if [ ! -e $image_path ] && [ -e $zip_path ]; then
    echo "No filesystem detected at ${image_path}!"
    echo "Extracting..."
    unzip $zip_path
    mv *.img $image_path
fi

exec qemu-system-arm \
  -M versatilepb \
  -cpu arm1176 \
  -m 256M \
  -hda /data/filesystem.img \
  -net nic \
  -net user,hostfwd=tcp::5022-:22 \
  -dtb /root/qemu-rpi-kernel/versatile-pb.dtb \
  -kernel /root/qemu-rpi-kernel/kernel-qemu-4.19.50-buster \
  -append "root=/dev/sda2 panic=1" \
  -no-reboot \
  -display none \
  -serial mon:stdio
