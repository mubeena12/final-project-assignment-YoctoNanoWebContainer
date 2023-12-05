#!/bin/bash

# Pull Docker webapp image
docker build --platform linux/arm64 . -t ghcr.io/mubeena12/docker-webapp:latest

# Start the sample postgres and webapp stack
cd docker
./start-stop-webapp.sh start

# Build Yocto image
git clone https://github.com/OE4T/tegra-demo-distro.git
cd tegra-demo-distro
git checkout --track origin/kirkstone-l4t-r32.7.x
git submodule update --init
. ./setup-env --machine jetson-nano-2gb-devkit

# Copy local.conf
cp <this-repo-clone-path>/jetson-nano-2gb-devkit/local.conf conf/local.conf

# Uncomment necessary lines in local.conf
sed -i '/^#DL_DIR/s/^#//' conf/local.conf
sed -i '/^#SSTATE_DIR/s/^#//' conf/local.conf
sed -i '/^#TMPDIR/s/^#//' conf/local.conf
echo 'IMAGE_INSTALL:append = " python3-docker-compose"' >> conf/local.conf
echo 'IMAGE_INSTALL:append = " python3-distutils"' >> conf/local.conf

# Build Yocto image
bitbake demo-image-full

# Deploy Yocto image on Jetson Nano
mkdir deploy
cd deploy
ln -s ../tmp/deploy/images/jetson-nano-2gb-devkit/demo-image-full-jetson-nano-2gb-devkit.tegraflash.tar.gz
tar -xvf demo-image-full-jetson-nano-2gb-devkit.tegraflash.tar.gz
sudo ./doflash.sh

# Verify Yocto image on Jetson Nano
ssh root@jetson-nano-2gb-devkit 'docker version && docker-compose version'
