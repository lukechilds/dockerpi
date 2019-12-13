FROM qemu/arm as dockerpi-vm
LABEL maintainer="Luke Childs <lukechilds123@gmail.com>"

ADD https://github.com/dhruvvyas90/qemu-rpi-kernel/archive/master.zip /tmp/qemu-rpi-kernel-master.zip

RUN unzip /tmp/qemu-rpi-kernel-master.zip -d ~ && rm -rf /tmp/*

VOLUME /filesystem.img

ENTRYPOINT ["qemu-system-arm"]
CMD [ \
  "-M", "versatilepb", \
  "-cpu", "arm1176", \
  "-m", "256", \
  "-hda", "/filesystem.img", \
  "-net", "nic", \
  "-net", "user,hostfwd=tcp::5022-:22", \
  "-dtb", "/root/qemu-rpi-kernel-master/versatile-pb.dtb", \
  "-kernel", "/root/qemu-rpi-kernel-master/kernel-qemu-4.19.50-buster", \
  "-append", "root=/dev/sda2 panic=1", \
  "-no-reboot", \
  "-display", "none", \
  "-serial", "mon:stdio" \
]

FROM dockerpi-vm as dockerpi
LABEL maintainer="Luke Childs <lukechilds123@gmail.com>"

ADD http://downloads.raspberrypi.org/raspbian/images/raspbian-2019-09-30/2019-09-26-raspbian-buster.zip /tmp/filesystem.zip

RUN unzip /tmp/*.zip && mv /tmp/*.img /filesystem.img && rm -rf /tmp/*
