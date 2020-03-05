#!/bin/sh

target="${1:-pi1}"
image_path="/sdcard/filesystem.img"
zip_path="/filesystem.zip"

if [ ! -e $image_path ]; then
  echo "No filesystem detected at ${image_path}!"
  if [ -e $zip_path ]; then
      echo "Extracting fresh filesystem..."
      unzip $zip_path
      mv -- *.img $image_path
  else
    exit 1
  fi
fi

fat_path="/fat.img"
if [ "${target}" != "pi1" ];
then
  echo "Extracting partitions"
  fdisk -l ${image_path} \
    | awk "/^[^ ]*1/{print \"dd if=${image_path} of=${fat_path} bs=512 skip=\"\$4\" count=\"\$6}" \
    | sh
fi
if [ "${target}" = "pi2" ];
then
  emulator=qemu-system-arm
  machine=raspi2
  memory=1024m
  kernel_pattern=kernel7.img
  dtb_pattern=bcm2709-rpi-2-b.dtb
  nic=''
elif [ "${target}" = "pi3" ];
then
  emulator=qemu-system-aarch64
  machine=raspi3
  memory=1024m
  kernel_pattern=kernel8.img
  dtb_pattern=bcm2710-rpi-3-b-plus.dtb
  nic=''
elif [ "${target}" = "pi1" ];
then
  emulator=qemu-system-arm
  kernel="/root/qemu-rpi-kernel/kernel-qemu-4.19.50-buster"
  dtb="/root/qemu-rpi-kernel/versatile-pb.dtb"
  machine=versatilepb
  memory=256m
  root=/dev/sda2
  nic='--net nic --net user,hostfwd=tcp::5022-:22'
else
  echo "Target ${target} not supported"
  echo "Supported targets: pi1 pi2 pi3"
  exit 2
fi

if [ -f "${fat_path}" ];
then
  echo "Extracting boot filesystem"
  fat_folder="/fat"
  mkdir -p "${fat_folder}"
  fatcat -x "${fat_folder}" "${fat_path}"
  echo "Searching for kernel='${kernel_pattern}'"
  kernel=$(find "${fat_folder}" -name "${kernel_pattern}")
  echo "Searching for dtb='${dtb_pattern}'"
  dtb=$(find "${fat_folder}" -name "${dtb_pattern}")
  root=/dev/mmcblk0p2
fi
if [ "${kernel}" = "" ] || [ "${dtb}" = "" ];
then
  echo "Missing kernel='${kernel}' or dtb='${dtb}'"
  exit 2
fi

echo "Booting with kernel=${kernel} dtb=${dtb}"
exec ${emulator} \
  --machine "${machine}" \
  --cpu arm1176 \
  --m "${memory}" \
  --hda "${image_path}" \
  ${nic} \
  --dtb "${dtb}" \
  --kernel "${kernel}" \
  --append "rw earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=${root} rootwait panic=1" \
  --no-reboot \
  --display none \
  --serial mon:stdio
