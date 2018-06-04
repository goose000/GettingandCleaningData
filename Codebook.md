# Codebook

## Codebook for Tidy Data Set


The data for the project were obtained from here:
    https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

A full description of these data, including background history can be obtained here:
    http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The R script called run_analysis.r downloads the raw data if there is not a folder labeled "ucidata" in the working directory. If the folder exists, it is assumed that the data has already been downloaded and all files placed in the top level of the folder. If it does not exist, the folder is created and all files are downloaded and unzipped into the folder. Two files are then produced by the summary: meansandsds.txt and summarydata.txt. 
meansandsds.txt is a data frame with the mean and standard deviation observations for each measurement type. Descriptive variable names are pulled from features.txt and descriptive activity labels pulled from activity_labels.txt and applied to the observations using the "Y" files. Finally, subject IDs are pulled from the subject files. Variable names use the same naming convention established in features_info
summarydata.txt is a tidy data frame with four variables:"subject", "activity", "measurementtype", and "mean". The first three variables are grouping variables, and "mean" is the average of the observations according to the grouping variables. 
