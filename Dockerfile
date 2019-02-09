FROM resin/rpi-raspbian:stretch
ENTRYPOINT []


###########################################################
# using curl and git to download pi cam interface binaries
# using netstat to check state of streaming server
# using vim as text editor
# using alsa as sound interface
###########################################################

RUN apt-get update && \  
  apt-get -qy install \
    curl git net-tools vim alsa-utils


################################
# everything will run in /root/
################################

WORKDIR /root/  


############################
# download and install node
############################

RUN curl -O \  
  https://nodejs.org/dist/v4.9.1/node-v4.9.1-linux-armv6l.tar.gz && \
  tar -xvf node-v4.9.1-linux-armv6l.tar.gz -C /usr/local --strip-components=1 && \
  rm node-v4.9.1-linux-armv6l.tar.gz


########################################
# install prerequisite for picam binary
########################################

RUN apt-get -qy install npm libharfbuzz0b libfontconfig1 libasound2 
RUN npm install coffee-script -g
RUN	mkdir -p /root/run/rec && \
	mkdir -p /root/run/hooks && \
	mkdir -p /root/run/state &&  \
	mkdir -p /root/picam/archive && \ 
	ln -sfn /root/picam/archive /root/run/rec/archive && \
	ln -sfn /root/run/rec /root/picam/rec && \
	ln -sfn /root/run/hooks /root/picam/hooks && \
	ln -sfn /root/run/state /root/picam/state  


####################################
# download and install picam binary
####################################

RUN curl -OL \
  https://github.com/iizukanao/picam/releases/download/v1.4.7-dev-4ch/picam-1.4.7-4ch-binary.tar.xz && \
  tar xvf picam-1.4.7-4ch-binary.tar.xz && \ 
  rm picam-1.4.7-4ch-binary.tar.xz && \
  cp picam-1.4.7-4ch-binary/picam ~/picam/


########################################
# download and install streaming server
########################################

RUN git clone https://github.com/iizukanao/node-rtsp-rtmp-server.git && \
	cd node-rtsp-rtmp-server && \
	npm install -d


##############################################
# create symlinks for libraries used by picam
##############################################

RUN	ln -s /opt/vc/lib/libopenmaxil.so /usr/lib/libopenmaxil.so && \
	ln -s /opt/vc/lib/libbcm_host.so /usr/lib/libbcm_host.so && \
	ln -s /opt/vc/lib/libvcos.so /usr/lib/libvcos.so &&  \
	ln -s /opt/vc/lib/libvchiq_arm.so /usr/lib/libvchiq_arm.so && \
	ln -s /opt/vc/lib/libbrcmGLESv2.so /usr/lib/libbrcmGLESv2.so && \
	ln -s /opt/vc/lib/libbrcmEGL.so /usr/lib/libbrcmEGL.so && \
	ln -s /opt/vc/lib/libGLESv2.so /usr/lib/libGLESv2.so && \
	ln -s /opt/vc/lib/libEGL.so /usr/lib/libEGL.so


#######################################
# copy over the start and stop scripts
#######################################

COPY /bin/start.sh /root/bin/start.sh
COPY /bin/stop.sh /root/bin/stop.sh
RUN chmod +x /root/bin/start.sh
RUN chmod +x /root/bin/stop.sh


####################################
# copy over streaming server config
####################################

COPY /config/config.coffee /root/node-rtsp-rtmp-server/config.coffee


##############################
# run start script at startup
##############################

CMD ["/root/bin/start.sh"]  
