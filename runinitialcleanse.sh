#!/bin/bash

studyids=("amish" "aric" "bags" "ccaf" "cfs" "chs" "copdgene" "cra" "dhs" "eocopd" "galaii" "genestar" "genoa" "gensalt" "goldn" "hchs" "hrmn" "hvh" "hypergen" "jhs" "mayovte" "mesa" "mghaf" "partners" "safs" "sage" "sarcoidosis" "sas" "thrv" "vafar" "vuaf" "wghs" "whi")
studyids2=("fhs")

for studyid in ${studyids[@]}; do
	bash initialdatacleanse.sh $studyid
done

for studyid in ${studyids2[@]}; do
	bash initialdatacleanse.sh $studyid "Y"
done
