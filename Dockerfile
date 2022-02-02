FROM debian:11

ENV DOCKER_NAME="debian-11"
ENV LANG C.UTF-8

#From https://www.tecmint.com/install-modsecurity-with-apache-on-debian-ubuntu/

RUN set -eux; \
	#export - suppress configuration question prompts
	export DEBIAN_FRONTEND=noninteractive; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		apt-utils; \
	apt-get -y upgrade; \
	apt-get install -y --no-install-recommends \
		procps wget tar less \
		apache2 libapache2-mod-security2 \
		ca-certificates p11-kit; 
#RUN a2enmod security2 (not required already enabled)
#RUN rm /etc/apache2/conf-enabled/*

COPY ./apache/apache2.conf /etc/apache2/apache2.conf
COPY ./apache/000-default.conf /etc/apache2/sites-available/000-default.conf

COPY ./modsec/modsecurity.conf /etc/modsecurity/modsecurity.conf
COPY ./modsec/crs-setup.conf /etc/modsecurity/crs-setup.conf
COPY ./modsec/security2.conf /etc/apache2/mods-enabled/security2.conf
COPY ./modsec/coreruleset/rules /etc/modsecurity/rules
COPY ./modsec/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf /etc/modsecurity/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf


RUN mkdir -p /app
WORKDIR /app
COPY ./entrypoint.sh /app/entrypoint.sh





