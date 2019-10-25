#!/bin/bash

NPROC=$(nproc --all)
#NPROC=$(sysctl -n hw.physicalcpu)

studyids=("sarcoidosis" "mghaf" "partners" "safs")
#studyids=("fhs" "mesa" "mghaf" "partners" "safs" "sage" "sarcoidosis" "sas" "thrv" "vafar" "vuaf" "wghs" "whi" "hvh" "jhs" "mayovte")
#studyids=("aric" "bags" "ccaf" "cfs" "chs" "copdgene" "cra" "dhs" "eocopd" "galaii" "genestar" "genoa" "gensalt" "goldn" "hchs" "hrmn" "hvh" "hypergen" "jhs"  

for studyid in ${studyids[@]}; do

	#pull runpartition.json and job.config
	aws s3 cp s3://stage-$studyid-etl/runpartition.json .

	# Set max number of threads to use
	sed "s/\"maxjobs\": 3/\"maxjobs\": $NPROC/" runpartition.json > runpartition2.json
	mv runpartition2.json runpartition.json

	python runpartition.py

done