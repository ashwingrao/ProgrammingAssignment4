rm(list=ls())
setwd("~/Documents/DropBox-AGR/Dropbox//Git/coursera//MySql/UCI HAR Dataset")


## Task 1 - Merges the training and the test sets to create one data set.

## Read Training Data - X, Y and Subject

train_X <- read.table(file ="train/X_train.txt",header = FALSE)
train_Y <- read.table(file ="train/y_train.txt",header = FALSE)
train_Subject <- read.table(file ="train/subject_train.txt",header = FALSE)

## Read Testing Data - X, Y & Subject
test_X <- read.table(file ="test/X_test.txt",header = FALSE)
test_Y <- read.table(file ="test/y_test.txt",header = FALSE)
test_Subject <- read.table(file ="test/subject_test.txt",header = FALSE)

## Merge Training & Testing Data

## --- X Data
final_X <- rbind(train_X, test_X)

## --- Y Data
final_Y <- rbind(train_Y, test_Y)

## --- Subject Data
final_Subject <- rbind(train_Subject, test_Subject)


## Get the names of Features from the features.txt file
featureNames <- read.table(file ="features.txt",header = FALSE)

## Get the names of activities from the activity_labels.txt
activityNames <- read.table(file ="activity_labels.txt",header = FALSE)

## Assign Column names of X data to information in featureNames
colnames(final_X) <- featureNames[,2]


## Replace "final_Y" entries with "Activity Names"
for (nameIndex in activityNames[,1]) {
  final_Y[which(final_Y$V1 == nameIndex),1] <- as.character(activityNames[nameIndex,2])
  #print(nameIndex)
  #print (activityNames[nameIndex,2])
}

## Extract Mean and Standard Deviations from the data
myfun <- function(column){any(grepl("std|mean", column))}
mean.and.std.col <- apply(featureNames, 1, myfun)
reducedFinal_X <- final_X[,mean.and.std.col]

## Verified by checking: egrep "std|mean" features.txt |wc -l

## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
## I am assuming that it means take only the mean columns and cbind the "final_Y" to that
myfun <- function(column){any(grepl("mean", column))}
mean.col <- apply(featureNames, 1, myfun)
tidyData <- final_X[,mean.col]
dim(tidyData)

## Verified by checking: egrep "mean" features.txt |wc -l
## Now add the "Y" values
tidyData <- cbind(tidyData,final_Y)

## Name the new column as Activity
colnames(tidyData)[colnames(tidyData)=="V1"] <- "Activity"

## Write this datainto a file
write.table(tidyData, file = "tidyset.txt", row.names = FALSE)
## Link URL = https://s3.amazonaws.com/coursera-uploads/user-24019cf3ccea477208923642/973498/asst-3/ec28b120b63111e49b9ac9d826808488.txt
submittedURL = "http://s3.amazonaws.com/coursera-uploads/user-24019cf3ccea477208923642/973498/asst-3/eb15c640b64c11e4b6ca4bd1faa92681.txt"
## Test the upload:
testDF <- read.table(submittedURL, header = TRUE)
head(testDF)


## Verify the run_analysis.R file
source("run_analysis.R")
## POST VALIDATION OF DATA
submittedURL = "http://s3.amazonaws.com/coursera-uploads/user-24019cf3ccea477208923642/973498/asst-3/be4a75e0b64f11e482dbc77dcc6b05ae.txt"
## Test the upload:
testDF <- read.table(submittedURL, header = TRUE)
head(testDF)