#!/bin/sh

set -ex
sudo apt-get update -y -q
sudo apt-get install -y -q ruby-dev build-essential p7zip-full rpm gdb libudev-dev qt5-default
sudo apt-get install -y -q fakeroot

# add libs not installed by default on Qt5.15/Qt6 any longer
sudo apt-get install -y -q libdbus-1-3 libxkbcommon-x11-0 libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-randr0 libxcb-render-util0 libxcb-xinerama0 libxcb-xfixes0 libxcb-cursor0

sudo chmod 777 /var/lib/gems/2.7.0
sudo chmod 777 /usr/local/bin
gem install public_suffix -v 5.1.1
gem install dotenv -v 2.8.1
gem install fpm -v 1.12.0 # Linux build fails using 1.13.0
pip install --upgrade pip
pip install -r src/requirements.txt
pip install -r src/requirements-${ARTISAN_OS}.txt

# copy the snap7 binary installed by pip
sudo cp -f ${PYTHON_PATH}/snap7/lib/libsnap7.so /usr/lib

.ci/install-libusb.sh
