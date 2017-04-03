#!/bin/bash
set -e
    
# Installing SoftHSM dependencies
sudo apt-get update -qq
sudo apt-get install autoconf -y
sudo apt-get install automake -y
sudo apt-get install libtool -y

# Installing OpenSSL
git clone https://github.com/openssl/openssl.git -b OpenSSL_1_0_2-stable
cd openssl
./config shared
make
sudo make install

cd ..

# Installing SoftHSM
git clone https://github.com/opendnssec/SoftHSMv2.git -b develop
cd SoftHSMv2
sh ./autogen.sh
./configure --with-openssl=/usr/local/ssl
make
sudo -E make install
cd ..
sudo ldconfig

# initializing SoftHSM
softhsm2-util --init-token --so-pin "12345" --pin "12345" --slot 0 --label "My slot 0"
