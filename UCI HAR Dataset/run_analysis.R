## Course Project for:
####### Getting and Cleaning Data Course Project #######

## Clean environment prior to starting
rm(list=ls())

## Make sure that you are in the folder with all files
if(!file.exists("test") || !file.exists("train") || !file.exists("activity_labels.txt") || !file.exists("features.txt")) {
  stop("All input files don't exist!")
}

###########################################################################
## Task 1 - Merges the training and the test sets to create one data set.
###########################################################################

print("Performing Task 1...")
## Read Training Data - X, Y and Subject

train_X <- read.table(file ="train/X_train.txt",header = FALSE)             # Read the X Training Values
train_Y <- read.table(file ="train/y_train.txt",header = FALSE)             # Read the Y Training Values
train_Subject <- read.table(file ="train/subject_train.txt",header = FALSE) # Read the Subject Training Values

## Read Testing Data - X, Y & Subject
test_X <- read.table(file ="test/X_test.txt",header = FALSE)                # Read the X Testing Values
test_Y <- read.table(file ="test/y_test.txt",header = FALSE)                # Read the Y Testing Values
test_Subject <- read.table(file ="test/subject_test.txt",header = FALSE)    # Read the Subject Testing Values

## Merge Training & Testing Data

## --- X Data
final_X <- rbind(train_X, test_X)                                           # Merge the X Values into "final_X"

## --- Y Data
final_Y <- rbind(train_Y, test_Y)                                           # Merge the Y Values into "final_Y"

## --- Subject Data
final_Subject <- rbind(train_Subject, test_Subject)                         # Merge the Subject Values into "final_Subject"


## Get the names of Features from the features.txt file
featureNames <- read.table(file ="features.txt",header = FALSE)             # Read the Feature labels from "features.txt"

## Get the names of activities from the activity_labels.txt
activityNames <- read.table(file ="activity_labels.txt",header = FALSE)     # Read the Activity labels from "activity_labels.txt"


###########################################################################
## Task 4 - Appropriately labels the data set with descriptive variable names. 
###########################################################################

print("Performing Task 4...")
## Assign Column names of X data to information in featureNames
colnames(final_X) <- featureNames[,2]                                       # Assign the Columnames to "final_X"

###########################################################################
## Task 3 - Uses descriptive activity names to name the activities in the data set
###########################################################################

print("Performing Task 3...")
## Replace "final_Y" entries with "Activity Names"
for (nameIndex in activityNames[,1]) {                                      # Loop through teh Activity Labels to map code to Factors
  final_Y[which(final_Y$V1 == nameIndex),1] <- as.character(activityNames[nameIndex,2])
}

###########################################################################
## Task 2 - Extracts only the measurements on the mean and standard deviation for each measurement. 
###########################################################################

print("Performing Task 2...")
## Assumption: "Mean" and "Standard Deviation" are named with tags *mean* and *std* respectively

myfun <- function(column){any(grepl("std|mean", column))}                   # Function to execute in apply. It identifies Std & Mean from vector
mean.and.std.col <- apply(featureNames, 1, myfun)                           # Apply the function to the rows (1)
reducedFinal_X <- final_X[,mean.and.std.col]                                # Use the Logical output to "extract" appropriate columns from final_X

## Verified by checking: egrep "std|mean" features.txt |wc -l

###########################################################################
## Task 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
###########################################################################

print("Performing Task 5...")

## Combine the Subject & Activity DFs to the independent variables.
task5_df <- cbind(reducedFinal_X, final_Subject)                                  # Add the Subject Column (Subject)
colnames(task5_df)[colnames(task5_df)=="V1"] <- "Subject"
task5_df <- cbind(task5_df, final_Y)                                       # Add the Dependent variable Column (Activity)
colnames(task5_df)[colnames(task5_df)=="V1"] <- "Activity"

## Now "Melt" the columns to allow us to run the mean on the data
library(reshape2)                                                          # Load the rshape2 library
melted_df <- melt(task5_df, id.vars = c("Subject", "Activity")             # Melt the DF into table with "Subject", "Activity", "Feature" and "Value"
                    ,variable.name = "Feature", value.name = "Value")

meanMeltedValues <- aggregate(melted_df$Value, list(Subject=melted_df$Subject,  # "Aggregate" the Values across Subject, Activity & Features, and perform the "Mean" function
                                                  Activity=melted_df$Activity, 
                                                  Feature= melted_df$Feature), 
                              mean)
                                                                            
colnames(meanMeltedValues)[colnames(meanMeltedValues)=="x"] <- "Value"     # Rename the new aggregate as "Value" for ease of understanding

tidyData <- dcast(meanMeltedValues, Subject + Activity ~ Feature, value.var = "Value") # DCast the array back to wide format
#dim(tidyData)

print("Generating \'tidyset.txt\' file")
## Write this datainto a file
write.table(tidyData, file = "tidyset.txt", row.names = FALSE)              # Write the table to a file called "tidyset.txt" which is later uploaded

## POST VALIDATION OF DATA
## submittedURL = "http://s3.amazonaws.com/coursera-uploads/user-24019cf3ccea477208923642/973498/asst-3/ec28b120b63111e49b9ac9d826808488.txt"
## Test the upload:
## testDF <- read.table(submittedURL, header = TRUE)
## head(testDF)
