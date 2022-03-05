#!/usr/bin/env zsh

# start ssh
/usr/bin/sshd

mkdir -p /root/.ssh

# .ssh files need be copyed instead of soft link
if [[ -e /data/.ssh ]]; then
    cp -v /data/.ssh/* /root/.ssh
    cat /data/.ssh/id_rsa.pub >>  /root/.ssh/authorized_keys
fi

if [[ -f /data/init.sh ]]; then
    zsh init.sh
fi

# prevent container from existing
tail -f /dev/null
