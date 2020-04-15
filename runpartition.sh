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
    echo $filename
    nohup java -jar DataAnalyzer.jar -propertiesfile $filename -Xmx${memory} > /var/logs/${configfile}.log &

    while [ $(ps aux | grep DataAnalyzer.jar | wc -l) -gt ${maxjobs} ]; do
    
       sleep .2

    done

done

for filename in ${resdir}${configfile}; do
    echo $filename
    nohup java -jar GenerateAllConcepts.jar -propertiesfile $filename -Xmx${memory} >> /var/logs/${configfile}.log &

    while [ $(ps aux | grep GenerateAllConcepts.jar | wc -l) -gt ${maxjobs} ]; do
        sleep 1
    done
done