#!/bin/bash

find completed/ -type f -exec rm -rf {} \;
find data/ -type f -exec rm -rf {} \;
find dict/ -type f -exec rm -rf {} \;
rm -rf mappings/mapping.csv
rm -rf mappings/mapping.csv.patient
find mappings/ -type f -exec rm -rf {} \;
find resources/ -type f -exec rm -rf {} \;
find processing/ -type f -exec rm -rf {} \;
rm -rf runpartition.json