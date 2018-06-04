library(data.table)
library(dplyr)

#Download File if not yet downloaded
if (!file.exists("./UCIData")) {dir.create("./UCIData")
        download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                      "./UCIData/UCIData.zip")
        dateDownloaded <- date()
}

#Unzip the data
unzip("./UCIData/UCIData.zip",overwrite=T,junkpaths=T,exdir = "./UCIData",
      unzip="internal")

#Extract the data parts

#Labels
activitylabels<-read.table("./UCIData/activity_labels.txt")
features<-read.table("./UCIData/features.txt",stringsAsFactors = F)

#subject ID
subjecttrain<-read.table("./UCIData/subject_train.txt")
subjecttest<-read.table("./UCIData/subject_test.txt")

#Measurements
Xtrain<-read.table("./UCIData/x_train.txt")
Xtest<-read.table("./UCIData/x_test.txt")

#activity types
Ytrain<-read.table("./UCIData/y_train.txt")  
Ytest<-read.table("./UCIData/y_test.txt") 



#merge the train and test sets to create one data set
Xdata<-rbind(Xtest,Xtrain)
Ydata<-rbind(Ytest,Ytrain)
subjectdata<-rbind(subjecttest,subjecttrain)
rm(Xtest,Xtrain,Ytest,Ytrain,subjecttest,subjecttrain)

#Extract only the measurements on the mean and standard deviation for each measurement

#identify desired columns
sdsandmeansindex<-grep("std|mean\\()",features[,2])

#select appropriate data
selecteddata<-select(Xdata,sdsandmeansindex)
rm(Xdata)

#assemble dataframe
meansandsdsdata=cbind(subjectdata,Ydata,selecteddata)
rm(subjectdata,Ydata,selecteddata)

#Label the data set with descriptive variable names
names(meansandsdsdata)<-c("subject","activity",features[sdsandmeansindex,2])
rm(sdsandmeansindex,features)

#Replace numeric identifiers with descriptive activity names 
#for activities in the data set 
for (i in seq_along(activitylabels[,1])) {
        meansandsdsdata$activity<-gsub(activitylabels[i,1],activitylabels[i,2],
                                       meansandsdsdata$activity)
}
rm(activitylabels,i)

#clean the measurement type labels by removing symbols
names(meansandsdsdata)<-gsub("-|_|\\()","",names(meansandsdsdata))

#Write the data to a file
write.table(meansandsdsdata, "./UCIData/meansandsds.txt", row.names = FALSE)


#Identify column names for measurement type columns
firstmeasurement<-names(meansandsdsdata[3])
lastmeasurment<-names(meansandsdsdata[length(names(meansandsdsdata))])

#collapse the dataframe into one long data set grouped by categorical data, and 
#with all measurements in the same column
skinnydata<-
        meansandsdsdata%>%
        gather(key="measurementtype",value="value",
               firstmeasurement:lastmeasurment)%>%
        group_by(subject,activity,measurementtype)
rm(firstmeasurement,lastmeasurment)

#create a second, independent tidy data set with the average of each variable 
#for each activity and each subject
summarydata<-summarise(skinnydata,mean=mean(value))
rm(skinnydata)

#Write the data to a file
write.table(summarydata, "./UCIData/summarydata.txt", row.names = FALSE)

