#!/bin/bash

# Copyright (c) 2013, Silvan Melchior
# All rights reserved.

# Redistribution and use, with or without modification, are permitted provided
# that the following conditions are met:
#    * Redistributions of source code must retain the above copyright
#      notice, this list of conditions and the following disclaimer.
#    * Neither the name of the copyright holder nor the
#      names of its contributors may be used to endorse or promote products
#      derived from this software without specific prior written permission.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# Description
# This script installs a browser-interface to control the RPi Cam. It can be run
# on any Raspberry Pi with a newly installed raspbian and enabled camera-support.
#
# Edited by jfarcher to work with github

case "$1" in

  remove)
        sudo killall raspimjpeg
        sudo apt-get remove -y apache2 php5 libapache2-mod-php5 gpac motion
        sudo apt-get autoremove -y

        sudo rm -r /var/www/*
        sudo rm /usr/local/bin/raspimjpeg
        sudo cp -r etc/rc_local_std/rc.local /etc/
        sudo chmod 755 /etc/rc.local

        echo "Removed everything"
        ;;

  autostart_run)
        sudo cp -r etc/rc_local_run/rc.local /etc/
        sudo chmod 755 /etc/rc.local
        echo "Changed autostart"
        ;;

  autostart_idle)
        sudo cp -r  etc/rc_local_idle/rc.local /etc/
        sudo chmod 755 /etc/rc.local
        echo "Changed autostart"
        ;;

  autostart_md)
        sudo cp -r  etc/rc_local_md/rc.local /etc/
        sudo chmod 755 /etc/rc.local
        echo "Changed autostart"
        ;;

  
  autostart_fp)
        sudo cp -r etc/rc_local_fp/rc.local /etc/
        sudo chmod 755 /etc/rc.local
        echo "Changed autostart"
        ;;

  autostart_no)
        sudo cp -r  etc/rc_local_std/rc.local /etc/
        sudo chmod 755 /etc/rc.local
        echo "Changed autostart"
        ;;

  install)
        sudo killall raspimjpeg
        git pull origin master
        sudo apt-get install -y apache2 php5 libapache2-mod-php5 gpac motion

        sudo cp -r www/* /var/www/
        sudo mkdir -p /var/www/media
        sudo chown -R www-data:www-data /var/www
        sudo mknod /var/www/admin/FIFO p
        sudo chmod 666 /var/www/admin/FIFO
        sudo cp -r etc/apache2/sites-available/default /etc/apache2/sites-available/
        sudo chmod 644 /etc/apache2/sites-available/default
        sudo cp etc/apache2/conf.d/other-vhosts-access-log /etc/apache2/conf.d/other-vhosts-access-log
        sudo chmod 644 /etc/apache2/conf.d/other-vhosts-access-log

        sudo cp -r bin/raspimjpeg /opt/vc/bin/
        sudo chmod 755 /opt/vc/bin/raspimjpeg
        sudo ln -s /opt/vc/bin/raspimjpeg /usr/bin/raspimjpeg

        sudo cp -r etc/rc_local_run/rc.local /etc/
        sudo chmod 755 /etc/rc.local

        sudo cp -r etc/motion/motion.conf /etc/motion/
        sudo chmod 640 /etc/motion/motion.conf

        echo "Installer finished"
        ;;

  start)
        shopt -s nullglob

        video=-1
        for f in /var/www/media/video_*.mp4; do
          video=`echo $f | cut -d '_' -f2 | cut -d '.' -f1`
        done
        video=`echo $video | sed 's/^0*//'`
        video=`expr $video + 1`

        image=-1
        for f in /var/www/media/image_*.jpg; do
          image=`echo $f | cut -d '_' -f2 | cut -d '.' -f1`
        done
        image=`echo $image | sed 's/^0*//'`
        image=`expr $image + 1`

        shopt -u nullglob

        sudo mkdir -p /dev/shm/mjpeg
        sudo raspimjpeg -w 512 -h 288 -wp 512 -hp 384 -d 1 -q 25 -of /dev/shm/mjpeg/cam.jpg -cf /var/www/admin/FIFO -sf /var/www/status_mjpeg.txt -vf /var/www/media/video_%04d_%04d%02d%02d_%02d%02d%02d.mp4 -if /var/www/media/image_%04d_%04d%02d%02d_%02d%02d%02d.jpg -p -ic $image -vc $video > /dev/null &
        echo "Started"
        ;;

  stop)
        sudo killall raspimjpeg
        echo "Stopped"
        ;;


  *)
        echo "No option selected"
        ;;

esac


