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
    backup_file /etc/hostname
    backup_file /etc/passwd
    backup_file /etc/shadow
    backup_file /etc/versions/variant
}

backup_file() {
    FILE_NAME=$1
    BACKUP_DIR=/media/bleemsync_prebackup

    mkdir -p "${BACKUP_DIR}"

    ls -l "${FILE_NAME}" >> "${BACKUP_DIR}/backup.log" 2>&1
    cp "${FILE_NAME}" "${BACKUP_DIR}/" >> "${BACKUP_DIR}/backup.log" 2>&1
    sync
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
