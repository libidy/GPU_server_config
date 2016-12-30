#!/bin/bash

trap "exit 2" SIGHUP SIGINT SIGTERM ERR

CUDA_VERSION="8.0"
CUDA_FILE="cuda-repo-ubuntu1404-8-0-local_8.0.44-1_amd64.deb"
CUDNN_FILE="cudnn-8.0-linux-x64-v5.1.tgz"
NVIDIA_DOCKER_FILE="nvidia-docker_1.0.0.rc.3-1_amd64.deb"

PYTHON_FILE="Python-2.7.12.tgz"
SETUPTOOLS_FILE="setuptools-32.1.2.zip"
PIP_FILE="pip-9.0.1.tar.gz"

# Update source aliyun
sudo cp sources.list /etc/apt
sudo apt-get update
sudo apt-get install ubuntu-extras-keyring

# Install some packages
sudo apt-get update && sudo apt-get -y upgrade
sudo apt-get -y install vim git make htop nload openssh-client openssh-server \
  bridge-utils nfs-common \
  zlib1g-dev unzip libssl-dev

# Install docker
cd ~/
./install_docker.sh
curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://89e6dbca.m.daocloud.io

# Install cuda
cd ~/Downloads
sudo dpkg -i ${CUDA_FILE}
sudo apt-get update
sudo apt-get -y install cuda

echo 'export CUDA_HOME=/usr/local/cuda' >> ~/.bashrc
echo "export PATH=/usr/local/cuda-${CUDA_VERSION}"'/bin:$PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
echo "" >> ~/.bashrc
source ~/.bashrc
cd /usr/local/cuda/samples
sudo make -j 24

# Install cudnn
cd ~/Downloads
tar xvzf ${CUDNN_FILE}
sudo cp -P cuda/include/cudnn.h /usr/local/cuda/include
sudo cp -P cuda/lib64/libcudnn* /usr/local/cuda/lib64
sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*

# Install nvidia-docker
# cd ~/Downloads
# sudo dpkg -i nvidia-docker*.deb && rm nvidia-docker*.deb

# Install python
cd ~/Downloads
tar -zxf ${PYTHON_FILE}
cd Python-*
./configure
make
sudo make install
echo 'export PYTHONPATH=/usr/local/lib/python2.7/dist-packages:$PYTHONPATH' >> ~/.bashrc
source ~/.bashrc

# Install setuptools
cd ~/Downloads
unzip ${SETUPTOOLS_FILE}
cd ~/Downloads/setuptools-*
sudo python setup.py build
sudo python setup.py install

# Install pip
cd ~/Downloads
tar -zxf ${PIP_FILE}
cd ~/Downloads/pip-*
sudo python setup.py build
sudo python setup.py install
cd ~/
mkdir -p ~/.pip
cd ~/.pip
echo -e "[global]\ntimeout=40\nindex-url=http://pypi.douban.com/simple/\n[install]\ntrusted-host=pypi.douban.com" > ./pip.conf

cd ~/
sudo pip install jsonpath-rw PyYAML jinja2


