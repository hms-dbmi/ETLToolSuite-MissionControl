#!/bin/bash

NPROC=$(nproc --all)
#NPROC=$(sysctl -n hw.physicalcpu)
studyids=("aric" "mesa" "fhs" "whi" "safs" "sage" "sarcoidosis" "sas" "thrv" "cfs" "chs" "copdgene" "cra")

studyids=( "bags" "ccaf" "dhs" "eocopd" "galaii" "genestar" "genoa" "gensalt" "goldn" "hchs" "hrmn" "hvh" "hypergen" "jhs" "mghaf" "partners" "vafar" "vuaf" "wghs" "hvh" "jhs" "mayovte")

#studyids=(   

for studyid in ${studyids[@]}; do

	#pull runpartition.json and job.config
	aws s3 cp s3://stage-$studyid-etl/runpartition.json .

	# Set max number of threads to use
	sed "s/\"maxjobs\": 3/\"maxjobs\": $NPROC/" runpartition.json > runpartition2.json
	mv runpartition2.json runpartition.json

	python runpartition.py

	aws s3 cp completed/ s3://stage-$studyid-etl/completed/ --recursive

done