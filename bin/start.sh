#!/bin/bash

if [ -f /root/node-rtsp-rtmp-server/config.coffee ]; then
	serverPort=$(grep "serverPort:" /root/node-rtsp-rtmp-server/config.coffee |  awk '{print $2}')
	if [ -z "$serverPort" ]; then
		echo Server port not found in ../config/config.coffee
		exit 1
	else
		echo Using server port $serverPort
	fi
else
	echo "../config/config.coffee does not exist"
	exit 1
fi

sleep 1

echo "Starting streaming server"
cd /root/node-rtsp-rtmp-server
./start_server.sh &

while [[ -z "$(netstat -an | grep :$serverPort)" ]]
do
        echo "... waiting 30 seconds for streaming server to come up"
        sleep 30
done

echo "Starting Pi Cam..."
cd /root/picam
./picam --alsadev hw:1,0 --rtspout -w 1136 -h 640 

