# Mission Control Basic Guide

This guide will show an example of how to generate the javabins needed to load an instance of HPDS.

For this example we will be using the NHANES data set.  Which is publicly available and hosted in a hms/dbmi s3 read only bucket.

## Prerequisites
In order to follow this guide you will need the following prerequisites.

* git credentials for hms/dbmi.
* AWS credentials ( Required if you want to pull and store the Nhanes data and configurations from s3 ).  
  or an ec2 instance with an attached iam role that allows access to avillach-73-nhanes-etl s3 bucket.
* An AWS ec2 ( All testing is done on Centos7 instances ) with sudo access.

## Setup:
Here we will prepare the ec2 by installing any required software and git projects on the ec2 to run the Nhanes ETL.

1.  ssh into the ec2.  If you are running this on a local machine ignore this step.
2.  Install JAVA:  ( all java processes are written in java8 and tested up to java11 )  
`su -c "yum install java-1.8.0-openjdk"`
3.  Install git:  
`su -c "yum install git"`
4.  clone the main Mission Control Project with tag v2.0.0  
`git clone --recurse-submodules -j8 --branch releasev1.0.0 https://github.com/hms-dbmi/ETLToolSuite-MissionControl`
5.  change directory to the Mission Control git project.  
`cd ETLToolSuite-MissionControl`
6.  add the Mission Control submodule for Nhanes.  
`git submodule add https://github.com/hms-dbmi/ETL-MissionControl-Nhanes-submodule`

## Executing the ETL:
In this section we will be executing a script that will create the allConcepts.csv that is required to create the javabins for HPDS:
*  Pulls necessary etl files ( data files, mapping file, job configuration ) from the nhanes s3 ( avillach-73-nhanes-etl )
*  executes the GenerateAllConcepts jar that will build the allConcepts.csv

1. In order to build the allConcepts.csv run the following command for the base directory of the ETLToolSuite-MissionControl project.  
`./ETL-MissionControl-Nhanes-submodule/buildAllConcepts.csv`

