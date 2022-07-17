#!/usr/bin/env zsh

# start ssh
/usr/bin/sshd

# do not use UID and GID
# UID GID is default in linux ,they may be overwritten by system value
USERNAME=vimer
MHOME=/home/${USERNAME}
MUID=${MUID:-1}
MGID=${MGID:-1}

mkdir -p ${MHOME}/.ssh

# .ssh files need be copyed instead of soft link
if [[ -e /data/.ssh ]]; then
    cp -v /data/.ssh/* $MHOME/.ssh
    cat /data/.ssh/id_rsa.pub >>  ${MHOME}/.ssh/authorized_keys
fi

if [[ -f /data/init.sh ]]; then
    zsh /data/init.sh
fi

if [[ $MUID -ne 1 && $MGID -ne 1 ]]; then
    echo "MGID $MGID"
    echo "MUID $MUID"
    echo "USERNAME $USERNAME"
    echo "chown begins..."
    groupmod -og ${MGID} ${USERNAME}
    usermod -ou ${MUID} ${USERNAME}
    #chown -R ${USERNAME}:${USERNAME} /data
    chown -R ${USERNAME}:${USERNAME} ${MHOME}
    echo "chown ends"
fi

# prevent container from existing
tail -f /dev/null
