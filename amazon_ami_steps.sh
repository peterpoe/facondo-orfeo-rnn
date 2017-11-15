#!/bin/bash

# Amazon AMI steps

sudo apt -y update
sudo apt -y install python2.7-dev
sudo apt -y install libhdf5-dev
sudo apt -y install python-pip
git clone https://github.com/torch/distro.git torch --recursive
cd torch
bash install-deps
./install.sh -b
cd ..
git clone https://github.com/jcjohnson/torch-rnn.git
cd torch-rnn
sudo -HE pip install pip --upgrade
sudo -HE pip install -r torch-rnn/requirements.txt --upgrade
sudo `which luarocks` install torch
sudo `which luarocks` install nn
sudo `which luarocks` install optim
sudo `which luarocks` install lua-cjson
git clone https://github.com/deepmind/torch-hdf5
sudo `which luarocks` make hdf5-0-0.rockspec

# TEST:
python scripts/preprocess.py  --input_txt data/tiny-shakespeare.txt  --output_h5 data/tiny-shakespeare.h5 --output_json data/tiny-shakespeare.json
th train.lua -input_h5 data/tiny-shakespeare.h5 -input_json data/tiny-shakespeare.json

# -----

cd /home/ec2-user
sudo yum update -y
sudo yum install gcc gcc-c++ git
wget ftp://ftp.hdfgroup.org/HDF5/current/src/hdf5-1.10.0-patch1.tar.gz
tar -xvzf hdf5-1.10.0-patch1.tar.gz
rm hdf5-1.10.0-patch1.tar.gz
cd hdf5-1.10.0-patch1
make
sudo mkdir /usr/local/hdf5
sudo chmod og+w /usr/local/hdf5
make install
export HDF5_DIR=/usr/local/hdf5
export PATH=$PATH:/usr/local/hdf5
cd ..
rm -rf hdf5-1.10.0-patch1
git clone https://github.com/torch/distro.git torch --recursive
cd torch
bash install-deps
./install.sh -b
cd ..
git clone https://github.com/jcjohnson/torch-rnn
sudo pip install --upgrade pip
sudo -E `which pip` install -r torch-rnn/requirements.txt
luarocks install torch
luarocks install nn
luarocks install optim
luarocks install lua-cjson
git clone https://github.com/deepmind/torch-hdf5
cd torch-hdf5
luarocks make hdf5-0-0.rockspec
cd ../torch-rnn
