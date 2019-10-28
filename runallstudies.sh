#!/bin/bash

NPROC=$(nproc --all)
#NPROC=$(sysctl -n hw.physicalcpu)

studyids=( "bags" )

#studyids=("aric" "mesa" "fhs" "whi" "safs" "sage" "sarcoidosis" "sas" "thrv" "cfs" "chs" "copdgene" "cra")

#studyids=( "bags" "ccaf" "dhs" "eocopd" "galaii" "genestar" "genoa" "gensalt" "goldn" "hchs" "hrmn" "hvh" "hypergen" "jhs" "mghaf" "partners" "vafar" "vuaf" "wghs" "hvh" "jhs" "mayovte")

for studyid in ${studyids[@]}; do

	# clean up folder structure and completed bucket in s3
	bash cleanupfolders.sh
	
	aws s3 rm s3://stage-$studyid-etl/completed/ --recursive

	# pull study folders
	aws s3 cp s3://stage-$studyid-etl/runpartition.json runpartition.json
	aws s3 cp s3://stage-$studyid-etl/resources/job.config resources/job.config
	aws s3 cp s3://stage-$studyid-etl/mappings/mapping.csv mappings/mapping.csv
	aws s3 cp s3://stage-$studyid-etl/mappings/mapping.csv.patient mappings/mapping.csv.patient
	aws s3 cp s3://stage-$studyid-etl/data/ data/ --recursive

	sed "s/datadelimiter.*/datadelimiter=,/" ./resources/job.config > ./resources/job2.config
	mv ./resources/job2.config ./resources/job.config
	sed "s/skipdataheader.*/skipdataheader=Y/" ./resources/job.config > ./resources/job2.config
	mv ./resources/job2.config ./resources/job.config

	aws s3 cp ./resources/job.config s3://stage-$studyid-etl/resources/job.config

	# Set max number of threads to use
	sed "s/\"maxjobs\": 3/\"maxjobs\": $NPROC/" runpartition.json > runpartition2.json
	mv runpartition2.json runpartition.json

	python runpartition.py

	aws s3 cp s3://stage-general-etl/data_evaluations/${studyid}_dataevaluation.txt ./resources/dataevaluation.txt

	aws s3 cp ./completed/ s3://stage-${studyid}-etl/completed/ --recursive

	aws s3 cp /var/logs/main.log s3://stage-general-etl/logs/${studyid}_main.log

	rm -rf /var/logs/*

done