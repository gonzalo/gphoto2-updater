#/bin/sh

# Gphoto2 2.5.1.1 compiler and installer script v0.2
#
# This script is specifically created for Raspbian http://www.raspbian.org
# and Raspberry Pi http://www.raspberrypi.org but should work over any 
# Debian-based distribution

# Created and mantained by Gonzalo Cao Cabeza de Vaca
# Please send any feedback or comments to gonzalo.cao(at)gmail.com
# Updated for gPhoto2 2.5.1.1 by Peter Hinson
# Updated for gPhoto2 2.5.2 by Dmitri Popov

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


if [ "$(whoami)" != "root" ]; then
	echo "Sorry, this script must be executed with sudo or as root"
	exit 1
fi

echo 
echo "----------------"
echo "Updating sources"
echo "----------------"
echo

apt-get update

echo 
echo "--------------------------"
echo "Removing gphoto2 if exists"
echo "--------------------------"
echo

apt-get remove -y gphoto2

echo 
echo "-----------------------"
echo "Installing dependencies"
echo "-----------------------"
echo

apt-get install -y libltdl-dev libusb-dev libexif-dev libpopt-dev

echo 
echo "-------------------------"
echo "Creating temporary folder"
echo "-------------------------"
echo

mkdir gphoto2-temp-folder
cd gphoto2-temp-folder

echo 
echo "-------------------------"
echo "Downloading libusb 1.0.11"
echo "-------------------------"
echo

wget http://ftp.de.debian.org/debian/pool/main/libu/libusbx/libusbx_1.0.11.orig.tar.bz2
tar xjvf libusbx_1.0.11.orig.tar.bz2
cd libusbx-1.0.11/

echo 
echo "--------------------------------------"
echo "Compiling and installing libusb 1.0.11"
echo "--------------------------------------"

./configure
make
make install
cd ..


echo 
echo "-------------------------"
echo "Downloading libusb 1.0.11"
echo "-------------------------"
echo

wget http://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.2/libgphoto2-2.5.2.tar.bz2
tar xjf libgphoto2-2.5.2.tar.bz2
cd libgphoto2-2.5.2

echo 
echo "-----------------------------------"
echo "Compiling and installing libgphoto2 2.5.2"
echo "-----------------------------------"
echo

./configure
make
make install
cd ..

echo 
echo "-------------------------"
echo "Downloading gphoto2 2.5.1"
echo "-------------------------"
echo

wget http://downloads.sourceforge.net/project/gphoto/gphoto/2.5.2/gphoto2-2.5.2.tar.gz
tar xzvf gphoto2-2.5.2.tar.gz
cd gphoto2-2.5.2

echo 
echo "--------------------------------"
echo "Compiling and installing gphoto2"
echo "--------------------------------" 
echo

./configure
make
make install
cd ..

echo 
echo "-----------------"
echo "Linking libraries"
echo "-----------------"  
echo

ldconfig

echo
echo "-----------------------------------------------------------------------------------------------"
echo "Setting up permissions for USB ports, see http://www.gphoto.org/doc/manual/permissions-usb.html"
echo "-----------------------------------------------------------------------------------------------"
echo
/usr/local/lib/libgphoto2/print-camera-list udev-rules version 0.98 group plugdev mode 0660 > /etc/udev/rules.d/90-libgphoto2.rules


echo 
echo "-------------------"
echo "Removing temp files"
echo "-------------------"
echo

cd ..
rm -r gphoto2-temp-folder



echo 
echo "--------------------"
echo "Finished!! Enjoy it!"
echo "--------------------"
echo

gphoto2 --version
