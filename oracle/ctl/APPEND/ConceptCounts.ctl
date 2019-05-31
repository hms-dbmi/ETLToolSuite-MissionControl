LOAD DATA 
INFILE 'ConceptCounts.csv'
BADFILE 'ConceptCounts.bad'
DISCARDFILE 'ConceptCounts.dsc'
APPEND 
INTO TABLE i2b2demodata.Concept_Counts
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY "`"
TRAILING NULLCOLS
( 
CONCEPT_PATH char(4000),
PARENT_CONCEPT_PATH char(4000),
PATIENT_COUNT
)