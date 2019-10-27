#!/bin/bash

NPROC=$(nproc --all)
#NPROC=$(sysctl -n hw.physicalcpu)
#studyids=("aric" "mesa" "fhs" "whi" "safs" "sage" "sarcoidosis" "sas" "thrv" "cfs" "chs" "copdgene" "cra")

#studyids=( "bags" "ccaf" "dhs" "eocopd" "galaii" "genestar" "genoa" "gensalt" "goldn" "hchs" "hrmn" "hvh" "hypergen" "jhs" "mghaf" "partners" "vafar" "vuaf" "wghs" "hvh" "jhs" "mayovte")

for studyid in ${studyids[@]}; do
	rm -rf completed/*
	aws s3 rm s3://stage-${studyid}-etl/completed/ --recursive
	#pull runpartition.json and job.config
	aws s3 cp s3://stage-${studyid}-etl/runpartition.json .
	aws s3 cp s3://stage-${studyid}-etl/resources/job.config ./resources/job.config

	sed "s/\datadelimiter.*\"datadelimiter=,/" ./resources/job.config > ./resources/job2.config
	mv ./resources/job2.config ./resources/job.config
	aws s3 cp ./resources/job.config s3://stage-${studyid}-etl/resources/job.config

	# Set max number of threads to use
	sed "s/\"maxjobs\": 3/\"maxjobs\": $NPROC/" runpartition.json > runpartition2.json
	mv runpartition2.json runpartition.json

	vi python runpartition.py

	aws s3 cp s3://stage-general-etl/data_evaluations/${studyid}_dataevalution.txt ./resources/dataevalution.txt

	expected_count=$(cat resources/dataevaluation.txt | grep 'Total expected patients:' | sed 's/Total expected patients: //')

	patcount=$(wc -l completed/PatientDimension.csv)

	if [[ expected_count == patcount ]]; 
		then
			aws s3 cp completed/ s3://stage-${studyid}-etl/completed/ --recursive
		else
			echo ${studyid} ' patient count does not match expected' 
			echo ${studyid} ' patient count does not match expected' > $(hostname)_badstudy.bad
			echo 'Actual patient count ' patcount 'expected_count'
			echo 'Actual patient count ' patcount 'expected_count' expected_count > $(hostname)_badstudy.bad
			aws s3 cp completed/ s3://stage-${studyid}-etl/completed/ --recursive
	fi

	aws s3 cp /var/logs/main.log s3://stage-general-etl/logs/${studyid}_main.log
	aws s3 cp $(hostname)_badstudys.bad s3://stage-general-etl/logs/$(hostname)_badstudys.bad

	rm -rf /var/logs/*

done