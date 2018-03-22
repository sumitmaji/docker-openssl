FROM sumit/jdk1.8:latest
MAINTAINER Sumit Kumar Maji

RUN apt-get update
RUN apt-get install -yq openssl
WORKDIR /usr/local/

ENV JAVA_HOME="/usr/local/jdk"
ENV PATH="$PATH:$JAVA_HOME/bin"
RUN mkdir -p /usr/local/certificates
ADD create_keytool_certificate.sh /
RUN chmod +x /create_keytool_certificate.sh
RUN mkdir -p /caCert
ADD caCert/ca.cert /caCert/ca.cert
ADD caCert/ca.key /caCert/ca.key 
RUN java -version
ENTRYPOINT ["/create_keytool_certificate.sh"]

