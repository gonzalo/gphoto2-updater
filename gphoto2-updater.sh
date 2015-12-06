#!/bin/bash

# Gphoto2 compiler and installer script v0.5
#
# This script is specifically created for Raspbian http://www.raspbian.org
# and Raspberry Pi http://www.raspberrypi.org but should work over any
# Debian-based distribution

# Created and mantained by Gonzalo Cao Cabeza de Vaca
# Please send any feedback or comments to gonzalo.cao(at)gmail.com
# Updated for gPhoto2 2.5.1.1 by Peter Hinson
# Updated for gPhoto2 2.5.2 by Dmitri Popov
# Updated for gphoto2 2.5.5 by Mihai Doarna
# Updated for gphoto2 2.5.6 by Mathias Peter
# Updated for gphoto2 2.5.7 by Sijawusz Pur Rahnama
# Updated for gphoto2 2.5.8 by scribblemaniac
# Updated for gphoto2 2.5.9 at GitHub by Gonzalo Cao
# Updated for last development release at GitHub by Gonzalo Cao

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


PS3='Please enter your choice: '
options=("Install last development version"
         "Install last stable release (2.5.9)"
				 "Quit")

select opt in "${options[@]}"
do
    case $opt in
        "Install last development version")
						echo
            echo "\"Install last development version\" selected"
						echo
						break
            ;;
        "Install last stable release (2.5.9)")
						echo
            echo "\"Install last stable release (2.5.9)\" selected"
						echo
						branch_libgphoto="--branch libgphoto2-2_5_9-release"
						branch_gphoto="--branch gphoto2-2_5_9-release"
						break
            ;;
        "Quit")
            exit 0
            ;;
        *) echo invalid option;;
    esac
done


echo
echo "----------------"
echo "Updating sources"
echo "----------------"
echo

apt-get update -qq

echo
echo "-----------------------------------------"
echo "Removing gphoto2 and libgphoto2 if exists"
echo "-----------------------------------------"
echo

apt-get remove -y gphoto2 libgphoto2-port10

echo
echo "-----------------------"
echo "Installing dependencies"
echo "-----------------------"
echo

apt-get install -y build-essential libltdl-dev libusb-dev libexif-dev libpopt-dev libudev-dev pkg-config git automake autoconf autopoint gettext libtool

echo
echo "-------------------------"
echo "Creating temporary folder"
echo "-------------------------"
echo

mkdir gphoto2-temp-folder
cd gphoto2-temp-folder

echo "gphoto2-temp-folder created"


echo
echo "-------------------------"
echo "Downloading libusb 1.0.20"
echo "-------------------------"
echo

if (wget -q http://downloads.sourceforge.net/project/libusb/libusb-1.0/libusb-1.0.20/libusb-1.0.20.tar.bz2)
	then
		tar jxf libusb-1.0.20.tar.bz2
		cd libusb-1.0.20/
	else
		echo "Unable to get libusb"
		echo "Exiting..."
		exit 1
fi

echo
echo "--------------------------------------"
echo "Compiling and installing libusb 1.0.20"
echo "--------------------------------------"

./configure
make
make install
cd ..


echo
echo "----------------------"
echo "Downloading libgphoto2"
echo "----------------------"
echo

if (git clone $branch_libgphoto https://github.com/gphoto/libgphoto2.git)
    then
        cd libgphoto2/
	else
		echo "Unable to get libgphoto2"
		echo "Exiting..."
		exit 1
fi


echo
echo "-----------------------------------"
echo "Compiling and installing libgphoto2"
echo "-----------------------------------"
echo

autoreconf --install --symlink
./configure
make
make install
cd ..

echo
echo "-------------------"
echo "Downloading gphoto2"
echo "-------------------"
echo

if (git clone  $branch_gphoto https://github.com/gphoto/gphoto2.git)
  then
        cd gphoto2
	else
		echo "Unable to get gphoto2"
		echo "Exiting..."
		exit 1
fi


echo
echo "--------------------------------"
echo "Compiling and installing gphoto2"
echo "--------------------------------"
echo

autoreconf --install --symlink
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
echo "---------------------------------------------------------------------------------"
echo "Generating udev rules, see http://www.gphoto.org/doc/manual/permissions-usb.html"
echo "---------------------------------------------------------------------------------"
echo

udev_version=$(udevd --version)

if   [ "$udev_version" -ge "201" ]
then
  udev_rules=201
elif [ "$udev_version" -ge "175" ]
then
  udev_rules=175
elif [ "$udev_version" -ge "136" ]
then
  udev_rules=136
else
  udev_rules=0.98
fi

/usr/local/lib/libgphoto2/print-camera-list udev-rules version $udev_rules group plugdev mode 0660 > /etc/udev/rules.d/90-libgphoto2.rules

if   [ "$udev_rules" = "201" ]
then
  echo
  echo "------------------------------------------------------------------------"
  echo "Generating hwdb file in /etc/udev/hwdb.d/20-gphoto.hwdb. Ignore the NOTE"
  echo "------------------------------------------------------------------------"
  echo
  /usr/local/lib/libgphoto2/print-camera-list hwdb > /etc/udev/hwdb.d/20-gphoto.hwdb
fi


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
