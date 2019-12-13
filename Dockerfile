FROM qemu/arm as dockerpi-vm
LABEL maintainer="Luke Childs <lukechilds123@gmail.com>"

ADD https://github.com/dhruvvyas90/qemu-rpi-kernel/archive/afe411f2c9b04730bcc6b2168cdc9adca224227c.zip /tmp/qemu-rpi-kernel.zip

RUN cd /tmp && mkdir -p /root/qemu-rpi-kernel && unzip qemu-rpi-kernel.zip && cp -r qemu-rpi-kernel-*/* /root/qemu-rpi-kernel/ && rm -rf /tmp/* /root/qemu-rpi-kernel/README.md /root/qemu-rpi-kernel/tools

VOLUME /filesystem.img

ENTRYPOINT ["qemu-system-arm"]
CMD [ \
  "-M", "versatilepb", \
  "-cpu", "arm1176", \
  "-m", "256", \
  "-hda", "/filesystem.img", \
  "-net", "nic", \
  "-net", "user,hostfwd=tcp::5022-:22", \
  "-dtb", "/root/qemu-rpi-kernel/versatile-pb.dtb", \
  "-kernel", "/root/qemu-rpi-kernel/kernel-qemu-4.19.50-buster", \
  "-append", "root=/dev/sda2 panic=1", \
  "-no-reboot", \
  "-display", "none", \
  "-serial", "mon:stdio" \
]

FROM dockerpi-vm as dockerpi
LABEL maintainer="Luke Childs <lukechilds123@gmail.com>"

ADD http://downloads.raspberrypi.org/raspbian/images/raspbian-2019-09-30/2019-09-26-raspbian-buster.zip /tmp/filesystem.zip

RUN cd /tmp && unzip *.zip && mv *.img /filesystem.img && rm -rf /tmp/*
