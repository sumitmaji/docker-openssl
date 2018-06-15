#!/bin/bash
#Script to create CA certificates

[[ "TRACE" ]] && set -x

: ${INSTALL_PATH:=$MOUNT_PATH/docker-openssl}

source $INSTALL_PATH/config


: ${COUNTRY:=IN}
: ${STATE:=UP}
: ${LOCALITY:=GN}
: ${ORGANIZATION:=CloudInc}
: ${ORGU:=IT}
: ${EMAIL:=cloudinc.gmail.com}
: ${COMMONNAME:=kube-system}

mkdir -p $CERTIFICATE_MOUNT_PATH/ca
pushd $CERTIFICATE_MOUNT_PATH/ca


if [ ! -f ca.key ]
then
openssl req -new -x509 -nodes -keyout ca.key -out ca.crt -days 3650 -passin pass:sumit \
-subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$ORGU/CN=$COMMONNAME/emailAddress=$EMAIL"
fi

popd
