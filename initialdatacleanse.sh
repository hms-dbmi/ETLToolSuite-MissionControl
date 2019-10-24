#!/usr/local/bin

# Clean up project before processing
rm -rf mappings/mapping.csv
rm -rf mappings/mapping.csv.patient
rm -rf completed/*
rm -rf data/*
rm -rf dict/*
rm -rf processing/*

NPROC=$(nproc --all)
echo $NPROC

cp template/job.config resources/job.config
# update job config trial id
sed "s/trialid.*/trailid=${1^^}/" resources/job.config > processing/new.config
sed "s/rootnode=.*/rootnode=/" processing/new.config > processing/new2.config
sed "s/dataquotedstring=.*/dataquotedstring=ç/" processing/new2.config > processing/new3.config
sed "s/datadelimiter=.*/datadelimiter=\t/" processing/new3.config > processing/new4.config

cp processing/new4.config resources/job.config

# update json config
sed "s/stage-.*-etl/stage-$1-etl/" runpartition.json > processing/new.json
sed "s/\"maxjobs\": 3/\"maxjobs\": $NPROC/" processing/new.json > processing/new2.json
cp processing/new2.json runpartition.json 

# Pull data and dictionaries
aws s3 cp s3://stage-$1-etl/rawData/data/ data/ --recursive
aws s3 cp s3://stage-$1-etl/rawData/dict/ dict/ --recursive

# Build Hierarchies
if [ "${2^^}" != "Y" ];
   then
      echo "then"
      java -jar DbgapTreeBuilder.jar -propertiesfile resources/job.config -data
   else
      echo "else"
      java -jar DbgapTreeBuilder.jar -propertiesfile resources/job.config -encodedlabel $2
fi

java -jar DataAnalyzer.jar -propertiesfile resources/job.config

# sync built structure ready for data load
aws s3 cp completed/ s3://stage-$1-etl/data/ --recursive
aws s3 cp mappings/mapping.csv s3://stage-$1-etl/mappings/mapping.csv
aws s3 cp mappings/bad_mappings.csv s3://stage-$1-etl/mappings/bad_mappings.csv
aws s3 cp mappings/mapping.csv.patient s3://stage-$1-etl/mappings/mapping.csv.patient
aws s3 cp data/ s3://stage-$1-etl/data/ --recursive

# Sync config files
aws s3 cp resources/job.config s3://stage-$1-etl/resources/job.config
aws s3 cp runpartition.json s3://stage-$1-etl/runpartition.json

# Run Data Evaluation
rm -rf data/*
rm -rf resources/dataevaluation.txt
rm -rf mappings/mapping.csv
rm -rf resources/job.config

aws s3 cp s3://stage-$1-etl/data/ data/ --recursive
aws s3 cp s3://stage-$1-etl/mappings/mapping.csv mappings/mapping.csv 
aws s3 cp s3://stage-$1-etl/resources/job.config resources/job.config

java -jar DataEvaluation.jar -propertiesfile resources/job.config

aws s3 cp resources/dataevaluation.txt s3://stage-general-etl/data_evaluations/$1_dataevaluation.txt

# Clean up dirs
#rm -rf mappings/mapping.csv
#rm -rf mappings/mapping.csv.patient
#rm -rf completed/*
#rm -rf data/*
#rm -rf dict/*
#rm -rf processing/*
