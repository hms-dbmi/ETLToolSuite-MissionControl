#!/bin/bash

studyids=("fhs" "mesa" "mghaf" "partners" "safs" "sage" "sarcoidosis" "sas" "thrv" "vafar" "vuaf" "wghs" "whi" "hvh" "jhs" "mayovte")
#studyids=("aric" "bags" "ccaf" "cfs" "chs" "copdgene" "cra" "dhs" "eocopd" "galaii" "genestar" "genoa" "gensalt" "goldn" "hchs" "hrmn" "hvh" "hypergen" "jhs"  
studyids2=("fhs")

for studyid in ${studyids[@]}; do
	bash initialdatacleanse.sh $studyid

done

for studyid in ${studyids2[@]}; do
	bash initialdatacleanse.sh $studyid "Y"

done
