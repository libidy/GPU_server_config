#!/bin/bash

trap "exit 2" SIGHUP SIGINT SIGTERM ERR

ANACONDA_VERSION="anaconda2-4.1.1"
ANACONDA_FILE="Anaconda2-4.1.1-Linux-x86_64.sh"

# Install pyenv
cd ~/
curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
echo 'export PATH="/home/lanlin/.pyenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
echo "" >> ~/.bashrc
source ~/.bashrc
echo 'export PIP_INDEX_URL=http://pypi.douban.com/simple/' >> ~/.bashrc
echo 'export PIP_TRUSTED_HOST=pypi.douban.com' >> ~/.bashrc
echo "" >> ~/.bashrc
source ~/.bashrc

# Install anaconda
mkdir -p ~/.pyenv/cache
cp ~/Downloads/${ANACONDA_FILE} ~/.pyenv/cache
pyenv install ${ANACONDA_VERSION}

# Install tensorflow, tensorlayer
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
pyenv activate ${ANACONDA_VERSION}
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
conda config --set show_channel_urls yes
conda remove -y mkl mkl-service
conda install -y nomkl numpy scipy scikit-learn numexpr
export TF_BINARY_URL=https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow-0.11.0-cp27-none-linux_x86_64.whl
pip install --ignore-installed --upgrade $TF_BINARY_URL
pip install tensorlayer
pyenv deactivate


