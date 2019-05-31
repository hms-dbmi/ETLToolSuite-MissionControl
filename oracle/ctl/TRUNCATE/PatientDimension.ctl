LOAD DATA 
INFILE 'PatientDimension.csv'
BADFILE 'PatientDimension.bad'
DISCARDFILE 'PatientDimension.dsc'
TRUNCATE 
INTO TABLE i2b2demodata.Patient_Dimension
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY "`"
TRAILING NULLCOLS
( 
PATIENT_NUM,
VITAL_STATUS_CD,
BIRTH_DATE DATE 'YYYY-MM-DD',
DEATH_DATE DATE 'YYYY-MM-DD',
SEX_CD,
AGE_IN_YEARS_NUM,
LANGUAGE_CD,
RACE_CD,
MARITAL_STATUS_CD,
RELIGION_CD,
ZIP_CD,
STATECITYZIP_PATH,
UPDATE_DATE "NVL(:UPDATE_DATE,sysdate)",
DOWNLOAD_DATE "NVL(:DOWNLOAD_DATE,sysdate)",
IMPORT_DATE "NVL(:IMPORT_DATE,sysdate)",
SOURCESYSTEM_CD,
UPLOAD_ID,
INCOME_CD,
PATIENT_BLOB
)