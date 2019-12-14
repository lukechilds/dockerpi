# dockerpi

[![Actions Status](https://badgen.net/github/checks/lukechilds/dockerpi?icon=github&label=Build%20Status)](https://github.com/lukechilds/dockerpi/actions)
[![Docker Pulls](https://badgen.net/docker/pulls/lukechilds/dockerpi?icon=docker&label=Docker%20pulls)](https://hub.docker.com/r/lukechilds/dockerpi/)
[![Docker Image Size](https://badgen.net/docker/size/lukechilds/dockerpi/latest/amd64?icon=docker&label=lukechilds/dockerpi)](https://hub.docker.com/r/lukechilds/dockerpi/tags?name=latest)
[![GitHub Donate](https://badgen.net/badge/GitHub/Sponsor/D959A7?icon=github)](https://github.com/sponsors/lukechilds)
[![Bitcoin Donate](https://badgen.net/badge/Bitcoin/Donate/F19537?icon=bitcoin)](https://blockstream.info/address/3Luke2qRn5iLj4NiFrvLBu2jaEj7JeMR6w)
[![Lightning Donate](https://badgen.net/badge/Lightning/Donate/F6BC41?icon=bitcoin-lightning)](https://tippin.me/@lukechilds)

> A Virtualised Raspberry Pi inside a Docker image

Gives you access to a virtualised ARM based Raspberry Pi machine running the Raspian operating system.

This is not just a Raspian Docker image, it's a full ARM based Raspberry Pi virtual machine environment.

## Usage

```
docker run -it lukechilds/dockerpi
```

By default all filesystem changes will lost on shutdown. You can persist filesystem changes between reboots by mounting the `/sdcard` volume on your host:

```
docker -v $HOME/.dockerpi:/sdcard run -it lukechilds/dockerpi
```

If you have a specific image you want to mount you can mount it at `/sdcard/filesystem.img`:

```
docker -v /2019-09-26-raspbian-buster-lite.img:/sdcard/filesystem.img run -it lukechilds/dockerpi
```

If you only want to mount your own image, you can download a much slimmer VM only Docker container that doesn't contain the Raspbian filesystem image:

[![Docker Image Size](https://badgen.net/docker/size/lukechilds/dockerpi/latest/amd64?icon=docker&label=lukechilds/dockerpi:latest)](https://hub.docker.com/r/lukechilds/dockerpi/tags?name=latest)
[![Docker Image Size](https://badgen.net/docker/size/lukechilds/dockerpi/vm/amd64?icon=docker&label=lukechilds/dockerpi:vm)](https://hub.docker.com/r/lukechilds/dockerpi/tags?name=vm)

```
docker -v /2019-09-26-raspbian-buster-lite.img:/sdcard/filesystem.img run -it lukechilds/dockerpi:vm
```

## Build

Build this image yourself by checking out this repo, `cd` ing into it and running:

```
docker build -t lukechilds/dockerpi .
```

## License

MIT © Luke Childs
