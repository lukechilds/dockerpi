FROM qemu/arm as dockerpi-vm
LABEL maintainer="Luke Childs <lukechilds123@gmail.com>"

ADD https://github.com/dhruvvyas90/qemu-rpi-kernel/archive/afe411f2c9b04730bcc6b2168cdc9adca224227c.zip /tmp/qemu-rpi-kernel.zip

RUN cd /tmp && \
    mkdir -p /root/qemu-rpi-kernel && \
    unzip qemu-rpi-kernel.zip && \
    cp -r qemu-rpi-kernel-*/* /root/qemu-rpi-kernel/ && \
    rm -rf /tmp/* /root/qemu-rpi-kernel/README.md /root/qemu-rpi-kernel/tools

VOLUME /data

ADD ./entrypoint.sh /entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]

FROM dockerpi-vm as dockerpi
LABEL maintainer="Luke Childs <lukechilds123@gmail.com>"
ADD http://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2019-09-30/2019-09-26-raspbian-buster-lite.zip /filesystem.zip
