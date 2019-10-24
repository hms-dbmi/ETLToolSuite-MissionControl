#!/bin/bash

studyids=("aric")
studyids2=()

for studyid in ${studyids[@]}; do
	bash initialdatacleanse.sh $studyid
done

for studyid in ${studyids2[@]}; do
	bash initialdatacleanse.sh $studyid "Y"
done
