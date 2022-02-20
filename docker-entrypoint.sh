#!/usr/bin/env zsh

# start ssh
/usr/bin/sshd

mkdir -p /root/.ssh

# .ssh files need be copyed instead of soft link
if [[ -e /data/.ssh ]]; then
    cp -v /data/.ssh/* /root/.ssh
fi

tail -f /dev/null
