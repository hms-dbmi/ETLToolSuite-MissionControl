#!/usr/local/bin

# remove files
rm -rf mappings/mapping.csv
rm -rf mappings/mapping.csv.patient
rm -rf completed/*
rm -rf data/*
rm -rf dict/*

# update job config trial id
sed "s/trialid.*/trailid=${1^^}/" resources/job.config > processing/new.config

# update json config
sed "s/stage-.*-etl/stage-$1-etl/" runpartition.json > processing/new.json

# Pull data and dictionaries
aws s3 cp s3://stage-$1-etl/rawData/data/ data/ --recursive
aws s3 cp s3://stage-$1-etl/rawData/dict/ dict/ --recursive

# Build Hierarchies
if [ "${2^^}" != "Y" ];
   then
      echo "then"
      java -jar DbgapTreeBuilder.jar -propertiesfile resources/job.config
   else
      echo "else"
      java -jar DbgapTreeBuilder.jar -propertiesfile resources/job.config -encodedlabel $2
fi

java -jar DataAnalyzer.jar -propertiesfile processing/new.config

# sync built structure ready for data load
aws s3 cp completed/ s3://stage-$1-etl/data/ --recursive
aws s3 cp mappings/mapping.csv s3://stage-$1-etl/mappings/mapping.csv
aws s3 cp mappings/bad_mappings.csv s3://stage-$1-etl/mappings/bad_mappings.csv
aws s3 cp mappings/mapping.csv.patient s3://stage-$1-etl/mappings/mapping.csv.patient

# Sync config files
aws s3 cp processing/new.config s3://stage-$1-etl/resources/job.config
aws s3 cp processing/new.json s3://stage-$1-etl/runpartition.json

#bash cleanupfolders.sh
