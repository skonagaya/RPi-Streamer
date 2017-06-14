#!/bin/bash

nodepid=$(ps -ef | grep "start_server.sh" | grep -v grep | awk '{print $2}')
nodekillresult=$(ps -ef | grep "start_server.sh" | grep -v grep | awk '{print $2}' | xargs kill 2>/dev/null)

campid=$(ps -ef | grep "picam" | grep -v grep | awk '{print $2}')
camkillresult=$(ps -ef | grep "picam" | grep -v grep | awk '{print $2}' | xargs kill 2>/dev/null)

coffeepid=$(ps -ef | grep "server.coffee" | grep -v grep | awk '{print $2}')
coffeekillresult=$(ps -ef | grep "server.coffee" | grep -v grep | awk '{print $2}' | xargs sudo kill -9 2>/dev/null)

if [ -z "$nodepid" ]
then
        echo -e "\nNode server process is already stopped...\n"
else
        echo -e "\nKilled Baby Cam node server [$nodepid]\n"
fi


if [ -z "$campid" ]
then
        echo -e "\nPi Cam process is already stopped...\n"
else
        echo -e "\nKilled Pi Cam [$campid]\n"
fi


if [ -z "$coffeepid" ]
then
        echo -e "\nCoffee process is already stopped...\n"
else
        echo -e "\nKilled Coffee [$coffeepid]\n"
fi

