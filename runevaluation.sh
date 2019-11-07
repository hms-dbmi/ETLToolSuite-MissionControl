#!/bin/bash

###
#
# Pulls data and mapping file from project for designated procet
# pass the project name 
#
studyids=("fhs" "jhs" "mesa" "copdgene")

for studyid in ${studyids[@]}; do

	aws s3 cp s3://stage-$1-etl/data/ data/ --recursive
	aws s3 cp s3://stage-$1-etl/mapping/mapping.csv mappings/mapping.csv
	aws s3 cp s3://stage-$1-etl/resources/job.config resources/job.config

	java -jar DataEvaluation.jar -propertiesfile resources/job.config

	aws s3 cp resources/dataevaluation.txt s3://stage-general-etl/$1_dataevaluation.txt

done
