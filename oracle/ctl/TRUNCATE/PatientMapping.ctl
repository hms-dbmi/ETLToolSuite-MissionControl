LOAD DATA 
INFILE 'PatientMapping.csv'
BADFILE 'PatientMapping.bad'
DISCARDFILE 'PatientMapping.dsc'
TRUNCATE 
INTO TABLE i2b2demodata.PATIENT_MAPPING
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY "`"
TRAILING NULLCOLS
( 
PATIENT_IDE,
PATIENT_IDE_SOURCE,
PATIENT_NUM,
SOURCESYSTEM_CD,
PROJECT_ID CONSTANT "ID",
UPLOAD_DATE SYSDATE,
DOWNLOAD_DATE SYSDATE,
IMPORT_DATE SYSDATE
)