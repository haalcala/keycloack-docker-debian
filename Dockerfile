FROM debian

ARG KEYCLOAK_ADMIN_USER="admin"
ARG KEYCLOAK_ADMIN_PASS="admin123"

ENV KEYCLOAK_ADMIN_USER=$KEYCLOAK_ADMIN_USER
ENV KEYCLOAK_ADMIN_PASS=$KEYCLOAK_ADMIN_PASS

RUN apt-get update \
	; apt-get install -y ca-certificates git curl gnupg2 lsb-release software-properties-common wget make unzip vim net-tools

RUN echo "deb http://nginx.org/packages/debian `lsb_release -cs` nginx" \
    | tee /etc/apt/sources.list.d/nginx.list

RUN curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -

RUN apt-key fingerprint ABF5BD827BD9BF62

RUN apt update \
	; apt install nginx

RUN curl -O https://dl.google.com/go/go1.14.4.linux-amd64.tar.gz \
	; tar -C /usr/local -xzf go1.14.4.linux-amd64.tar.gz ; rm -f go1.14.4.linux-amd64.tar.gz

RUN curl -O https://download.java.net/java/GA/jdk14.0.2/205943a0976c4ed48cb16f1043c5c647/12/GPL/openjdk-14.0.2_linux-x64_bin.tar.gz \
	; tar xvzf openjdk-14.0.2_linux-x64_bin.tar.gz \
	; rm openjdk-14.0.2_linux-x64_bin.tar.gz

RUN curl -O https://downloads.jboss.org/keycloak/11.0.2/keycloak-11.0.2.zip \
	; unzip keycloak-11.0.2.zip ; rm keycloak-11.0.2.zip

#RUN curl -O http://nginx.org/download/nginx-1.18.0.tar.gz \
#	; tar xvzf nginx-1.18.0.tar.gz \
#	; rm nginx-1.18.0.tar.gz


ENV JAVA_HOME=/jdk-11.0.2
ENV PATH="$PATH:/usr/local/go/bin:/jdk-11.0.2/bin"

WORKDIR /keycloak-11.0.2

RUN ./bin/add-user-keycloak.sh -u $KEYCLOAK_ADMIN_USER -p $KEYCLOAK_ADMIN_PASS

RUN cat ./standalone/configuration/standalone.xml | sed -e 's/jboss.bind.address:127.0.0.1/jboss.bind.address:0.0.0.0/' | sed -e 's/jboss.bind.address.management:127.0.0.1/jboss.bind.address.management:0.0.0.0/' > ./standalone/configuration/standalone.xml.tmp ; cp ./standalone/configuration/standalone.xml.tmp ./standalone/configuration/standalone.xml

EXPOSE 8080
EXPOSE 9990

# ENTRYPOINT "./bin/standalone.sh"

CMD "./bin/standalone.sh"