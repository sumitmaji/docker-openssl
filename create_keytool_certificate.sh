#!/bin/bash
#Create .jsk certificates

[[ "TRACE" ]] && set -x

: ${COUNTRY:=IN}
: ${STATE:=UP}
: ${LOCALITY:=GN}
: ${ORGANIZATION:=CloudInc}
: ${ORGU:=IT}
: ${EMAIL:=cloudinc.gmail.com}
: ${COMMONNAME:=openssl.cloud.com}

cd /usr/local/certificates

domain=$1
password=$2
mkdir $domain
pushd $domain

#Create a keystore
cp /caCert/ca.cert /caCert/ca.key .
keytool -genkey -validity 730 -noprompt \
 -alias $domain \
 -dname "CN=$domain, OU=CloudInc O=IT, L=IN, S=UP, C=GN" \
 -keystore $domain.jks \
 -storepass $password \
 -keypass $password

#Create a certificate request for the appropriate key (referenced by its alias)
keytool -keystore $domain.jks -alias $domain -certreq -file $domain-cert-req.csr \
 -storepass $password \
 -keypass $password

#openssl req -new -x509 -keyout ca.key -out ca.cert -days 3650 -passin pass:sumit\
 -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$ORGU/CN=$COMMONNAME/emailAddress=$EMAIL"

#The command syntax used to create the certificate using the CSR file is
openssl x509 -req -CA ca.cert -CAkey ca.key -in $domain-cert-req.csr -out $domain-signed-cert.crt -days 730 \
 -CAcreateserial -passin pass:sumit

#Import the trusted CA certificate ca.cert that was created above into the keystore used on each node.
keytool -keystore $domain.jks -alias CARoot -import -file ca.cert -noprompt\
  -storepass $password \
 -keypass $password

#Import the certificate that was created for the key used on each other node.
keytool -keystore $domain.jks -alias $domain -import -file $domain-signed-cert.crt \
 -storepass $password \
 -keypass $password

#Confirm that the CA and signed certificate are in your keystore. In the above interaction example, each of the keys created and added to the keystore paired with the signed certificate that was created should be listed.
keytool -list -v -keystore $domain.jks \
 -storepass $password \
 -keypass $password
rm -rf ca.cert ca.key
$popd
