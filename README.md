gphoto2-updater
===============

Gphoto2 and libGphoto2 compiler and installer script
http://github.com/gonzalo/gphoto2-updater

This script allows to install last development (currently 2.5.9.1) and last
stable (2.5.9) releases of gphoto2 and libGphoto2 based on
[git repositories](https://github.com/gphoto/)

This script was initially created for Raspbian http://www.raspbian.org
and Raspberry Pi http://www.raspberrypi.org but it is also tested for Ubuntu
14.04 and Debian Jessie and Wheezy.

Created and mantained by Gonzalo Cao Cabeza de Vaca
Please send any feedback or comments to gonzalo.cao(at)gmail.com

Special thanks to @scribblemaniac for his support on this project.

How-to use
==========
To download and compile last script version just be sure you are connected to
the Internet and run:

```
$ wget https://raw.githubusercontent.com/gonzalo/gphoto2-updater/master/gphoto2-updater.sh && chmod +x gphoto2-updater.sh && sudo ./gphoto2-updater.sh
```
Then select between stable and development version

Check releases
https://github.com/gonzalo/gphoto2-updater/releases

Testing script using Docker containers
======================================
In order to test pull requests without touching my OS, I'm using customized Docker images of ubuntu 14.04, debian 7 and debian 8 to automatically download and execute that new git branches. Here you can find a complete blog post explaining the thing (in spanish).

http://blog.zoogon.net/2016/03/usando-docker-para-crear-maquinas.html

The main advantage is that everytime you will need it, you will have an updated and clean OS image just with git installed. After every execution the container remains clean without any change.

The quick way to create a customized ubuntu 14.04 container:

1.- Install docker (sudo apt-get install docker)

2.- Move to a new folder and create a file named "Dockerfile" with this contents to define your customized container.
```
FROM ubuntu:14.04
RUN apt-get -y update && apt-get install -y git
COPY ./test-script.sh /
```
3.- Create a file named test-script.sh to store the script that docker builder will copy to container to download and execute the desired Git branch.
```
#!/usr/bin/env bash
git clone $1
cd gphoto2-updater
./gphoto2-updater.sh
```
4.- Now build your customized container (it will remain stored in your local system)
```
docker build -t ubuntu-14.04-git .
```
5.- Done! 

Now you can test a Git branch everytime you need it over an clean ubuntu 14.04 container just running:
```
docker run -ti ubuntu-14.04-git /test-script.sh [http-url-of-git-branch]
```

Docker will init a fresh instance on ubuntu 14.04, clone the git branch of the gphoto and run the gphoto2-updater script. After execution, the container is closed and changes will dissapear.

Similar actions can be done to generate customized debian 7 and debian 8 images. In fact I've created a script to test gphoto2-updater just as follows:
```
./test-os.sh [customized-image] [url-to-git-branch]
```
Example: 
```
./test-os.sh ubuntu-14.04-git https://github.com/gonzalo/gphoto2-updater.git
```


LICENSE AND DISCLAIMER
======================

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
