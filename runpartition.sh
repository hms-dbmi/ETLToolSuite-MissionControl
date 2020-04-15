#!/bin/bash

while getopts m:j:c:r: option
do
case "${option}"
in
        m) memory=${OPTARG};;
        j) maxjobs=${OPTARG};;
        c) configfile=${OPTARG};;
        r) resdir=${OPTARG};;
esac
done

for filename in ${resdir}${configfile}; do

        nohup java -jar DataAnalyzer.jar -propertiesfile $filename -Xmx${memory} > /var/logs/${configfile}.log 2>&1 &

        if [ $(ps aux | grep DataAnalyzer.jar | wc -l) -gt ${maxjobs} ]
           then
                sleep .1
        fi

done

for filename in ${resdir}${configfile}; do

        nohup java -jar GenerateAllConcepts.jar -propertiesfile $filename -Xmx${memory} >> /var/logs/${configfile}.log 2>&1 &

        if [ $(ps aux | grep GenerateAllConcepts.jar | wc -l) -gt ${maxjobs} ]
           then
                sleep 1
        fi
done