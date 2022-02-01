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
		procps \
		wget \
		tar \
		less \
		git \
		apache2 \
		libapache2-mod-security2 \
		ca-certificates p11-kit; 
#RUN a2enmod security2 (not required already enabled)
#RUN rm /etc/apache2/conf-enabled/*
RUN service apache2 restart

#COPY modsecurity.conf /etc/modsecurity/modsecurity.conf

#COPY apache2.conf /etc/apache2/apache2.conf

RUN mkdir /app
WORKDIR /app
RUN git clone https://github.com/coreruleset/coreruleset.git
RUN mv ./coreruleset/crs-setup.conf.example /etc/modsecurity/crs-setup.conf
#RUN mv ./rules/ /etc/modsecurity/

#COPY security2.conf /etc/apache2/mods-enabled/security2.conf
#IncludeOptional /etc/modsecurity/*.conf
#Include /etc/modsecurity/rules/*.conf

#COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

RUN service apache2 restart
ENTRYPOINT ["tail", "-f", "/dev/null"]





