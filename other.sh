#!/bin/bash
#title           :orange.sh
#description     :Read values from SDM230 and sends it to Domoticz.
#author		 :jgronowski
#date            :20171123
#version         :0.1
#usage		 :./orange.sh
#notes           :
#bash_version    :
#==============================================================================
SERVER="http://192.168.1.33:8080"   #server location
IDXV=7	  #id of your device for voltage
IDXC=8	  #id of your device for current
IDXP=6 	  #id of your device for power
IDXF=9   #id of your device for frequency
IDXE=10   #id of your device for energy

VALUES=NOK
#echo $VALUES #Debugging line
while [ "$VALUES" = "NOK" ]
do
        VALUES=`/home/pi/SDM120C/sdm120c /dev/ttyUSB0 -v -c -p -f -i -q -w2 -PN` #i=imported / e=exported / q=short outpu
#       echo $VALUES #Debugging line
done
        VOLTAGE=`echo $VALUES | cut -d ' ' -f1`
        CURRENT=`echo $VALUES | cut -d ' ' -f2`
	POWER=`echo $VALUES | cut -d ' ' -f3`
	FREQUENCY=`echo $VALUES | cut -d ' ' -f4`
	IMPORT=`echo $VALUES | cut -d ' ' -f5`
	COUNTER=11269320 # adjust your measurment with your main energy meter
	ENERGY=`echo $COUNTER + $IMPORT | bc`


curl -s {$SERVER"/json.htm?type=command&param=udevice&idx="$IDXV"&nvalue=0&svalue="$VOLTAGE""}  #send to domoticz
curl -s {$SERVER"/json.htm?type=command&param=udevice&idx="$IDXC"&nvalue=0&svalue="$CURRENT""}  #send to domoticz
curl -s {$SERVER"/json.htm?type=command&param=udevice&idx="$IDXP"&nvalue=0&svalue="$POWER""}  #send to domoticz
curl -s {$SERVER"/json.htm?type=command&param=udevice&idx="$IDXF"&nvalue=0&svalue="$FREQUENCY""}  #send to domoticz
curl -s {$SERVER"/json.htm?type=command&param=udevice&idx="$IDXE"&nvalue=0&svalue="$ENERGY""}  #send to domoticz

#echo $ENERGY/1000 | bc -l
