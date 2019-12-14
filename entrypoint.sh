#!/bin/sh

image_path="/sdcard/filesystem.img"
zip_path="/filesystem.zip"

if [ ! -e $image_path ]; then
  echo "No filesystem detected at ${image_path}!"
  if [ -e $zip_path ]; then
      echo "Extracting fresh filesystem..."
      unzip $zip_path
      mv *.img $image_path
  else
    exit 1
  fi
fi

exec qemu-system-arm \
  --machine versatilepb \
  --cpu arm1176 \
  --m 256M \
  --hda /sdcard/filesystem.img \
  --net nic \
  --net user,hostfwd=tcp::5022-:22 \
  --dtb /root/qemu-rpi-kernel/versatile-pb.dtb \
  --kernel /root/qemu-rpi-kernel/kernel-qemu-4.19.50-buster \
  --append "root=/dev/sda2 panic=1" \
  --no-reboot \
  --display none \
  --serial mon:stdio
