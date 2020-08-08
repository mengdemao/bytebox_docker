#!/bin/bash
export PATH=$PATH:gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabihf/bin:gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabi/bin
cd /playground
make
eval $*
