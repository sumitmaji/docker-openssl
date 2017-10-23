#!/bin/bash

while [ $# -gt 0 ]
do
    case "$1" in
        '-d')  domain="$2";;
    esac
    shift
    case "$1" in
        '-p')  pwd="$2";;
    esac
done

if [ -z "$domain" ]
then
  echo "Domain is required!!!!!!"
  exit 1
elif [ -z "$pwd" ]
then
  echo "Password is required!!!!"
  exit 1
fi

docker run -it --rm -e ENABLE_KRB='true' -v /home/sumit/certificates:/usr/local/certificates --name openssl -h openssl.cloud.com --net cloud.com  sumit/openssl:latest $domain $pwd 


