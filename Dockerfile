FROM debian:jessie
MAINTAINER Johan Adriaans <johan@shoppagina.nl>

ENV DEBIAN_FRONTEND noninteractive

# Add the dumb-init source
ADD dumb-init /usr/src/dumb-init

# Runit and dumb-init
RUN apt-get update && apt-get install -y runit locales vim.tiny build-essential \
  && cd /usr/src/dumb-init \
  && make \
  && mv /usr/src/dumb-init/dumb-init /sbin/ \
  && mkdir /etc/service \
  && cd / \
  && rm -rf /usr/src/dumb-init \
  && apt-get remove -y build-essential \
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/* \

 # Locale and timezone settingsa
 ENV TZ=Europe/Amsterdam
 RUN locale-gen nl_NL.UTF-8 nl_nl && locale-gen en_US.UTF-8 en_us && dpkg-reconfigure locales && locale-gen C.UTF-8 && /usr/sbin/update-locale LANG=C.UTF-8 && \
   echo $TZ > /etc/timezone && \
   ln -snf /usr/share/zoneinfo/$TZ /etc/localtime

ENTRYPOINT ["/sbin/dumb-init", "/usr/bin/runsvdir", "-P", "/etc/service"]
