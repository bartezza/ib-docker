
FROM ubuntu:16.04
# FROM python:3.7-slim

RUN  apt-get update \
  && apt-get install -y wget unzip xvfb libxtst6 libxrender1 libxi6 socat \
    software-properties-common x11vnc locales

# https://stackoverflow.com/questions/28405902/how-to-set-the-locale-inside-a-debian-ubuntu-docker-container
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8 
ENV LC_ALL en_US.UTF-8

# Setup IB TWS
RUN mkdir -p /opt/TWS
WORKDIR /opt/TWS
RUN wget -q http://cdn.quantconnect.com/interactive/ibgateway-latest-standalone-linux-x64-v974.4g.sh
RUN chmod a+x ibgateway-latest-standalone-linux-x64-v974.4g.sh

# Install TWS
RUN yes n | /opt/TWS/ibgateway-latest-standalone-linux-x64-v974.4g.sh

# Setup  IBController
#RUN mkdir -p /opt/IBController/
#WORKDIR /opt/IBController/
#RUN wget -q http://cdn.quantconnect.com/interactive/IBController-QuantConnect-3.2.0.5.zip
#RUN unzip ./IBController-QuantConnect-3.2.0.5.zip
#RUN chmod -R u+x *.sh && chmod -R u+x Scripts/*.sh

RUN mkdir -p /opt/IBC
WORKDIR /opt/IBC
RUN wget -q https://github.com/IbcAlpha/IBC/releases/download/3.8.1/IBCLinux-3.8.1.zip
RUN unzip ./IBCLinux-3.8.1.zip
RUN chmod -R u+x *.sh && chmod -R u+x scripts/*.sh

# Launch a virtual screen
#RUN Xvfb :1 -screen 0 1024x768x24 2>&1 >/dev/null &
#RUN export DISPLAY=:1

ADD externals/ib-docker/IBController.ini /root/IBC/config.ini
ADD externals/ib-docker/jts.ini /root/Jts/jts.ini

WORKDIR /

ARG VNC_PASSWORD
# ADD runscript.sh runscript.sh
ADD externals/ib-docker/runscript.sh runscript.sh
CMD bash runscript.sh
