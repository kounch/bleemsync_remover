#!/bin/sh

# BSD 2-Clause License
# 
# Copyright (c) 2019, kounch
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
# 
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

main() {
    mount -o remount,rw /

    systemctl stop ftp.socket
    systemctl disable ftp.socket
    systemctl stop telnet.socket
    systemctl disable telnet.socket
    systemctl stop bleemsync.service
    systemctl disable bleemsync.service
	systemctl daemon-reload

    rm -f /etc/systemd/system/telnet.socket
    rm -f /etc/systemd/system/telnet@.service
    rm -f /etc/systemd/system/ftp.socket
    rm -f /etc/systemd/system/ftp@.service
    rm -f /etc/systemd/system/bleemsync.service

    for mod in /opt/bleemsync_kernel/*.ko; do rmmod "$mod"; done
    rm -rf /opt/bleemsync_kernel/

    rm -f /data/rndis-mac-address
    #rm -rf /sys/class/android_usb/android0/*

    rm -f /usr/bin/motd-bs 
    rm -f /etc/profile.d/motd-bs.sh
    rm -f /usr/bin/busybox-bs
    rm -f /usr/bin/bleemsync_service
    rm -f /usr/bin/mount.exfat
    rm -f /usr/bin/mount.ntfs
    rm -f /sbin/mount.exfat
    rm -f /sbin/mount.ntfs
    rm -f /etc/versions/bleemsync_loader.ver

	rm -f /sbin/blkid
    ln -s /bin/busybox.nosuid /sbin/blkid
    echo "aiv8167-rockman-emmc" > /etc/hostname
    echo "user" >  /etc/versions/variant
    usermod -p '*' root

    mount -o remount,ro /
}

#Notify start
echo 0 > /sys/class/leds/green/brightness
echo 1 > /sys/class/leds/red/brightness

main
sync
sleep 2s

#Notify end
echo 0 > /sys/class/leds/green/brightness
echo 0 > /sys/class/leds/red/brightness

poweroff
