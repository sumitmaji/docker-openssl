#!/bin/bash
[[ "TRACE" ]] && set -x

: ${INSTALL_PATH:=$MOUNT_PATH/openssl}

source $INSTALL_PATH/config


while [[ $# -gt 0 ]]
do
key="$1"
case $key in
 -i|--ip)
 NODE_IP="$2"
 shift
 shift
 ;;
 -h|--host)
 HOSTNAME="$2"
 shift
 shift
 ;;
esac
done

if [ -z "$HOSTNAME" ]
then
        echo "Please provide node hostname"
        exit 1
fi

: ${COUNTRY:=IN}
: ${STATE:=UP}
: ${LOCALITY:=GN}
: ${ORGANIZATION:=CloudInc}
: ${ORGU:=IT}
: ${EMAIL:=cloudinc.gmail.com}
: ${COMMONNAME:=kube-system}

mkdir -p $CERTIFICATE_MOUNT_PATH/$HOSTNAME
pushd $CERTIFICATE_MOUNT_PATH/$HOSTNAME

cp -R $CERTIFICATE_MOUNT_PATH/ca/* .

cat <<EOF | sudo tee node-openssl.cnf
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
IP.1 = 127.0.0.1
EOF

openssl genrsa -out node.key 2048

openssl req -new -key node.key \
-subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$ORGU/CN=$HOSTNAME/emailAddress=$EMAIL" \
-out node.csr -config node-openssl.cnf

openssl x509 -req -in node.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out node.crt \
-days 10000 -extensions v3_req -extfile node-openssl.cnf

openssl x509 -noout -text -in node.crt

popd
