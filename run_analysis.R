library(tibble)
library(data.table)
library(dplyr)
library(Hmisc)
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)

features <- read.table("./UCI HAR Dataset/features.txt") #Import list of features
#Extracts the appropriate column numbers for standard deviation and mean values from list of features:
columnsStd <- grep("std\\(\\)", features[[2]]) # Standard deviation
columnsMean <- grep("mean\\(\\)", features[[2]]) # Mean
columnsVector <- c(columnsMean, columnsStd) # Combine to make vector of column numbers to be extracted from data
columnNames <- as.character(features[[2]][columnsVector]) # Makes vector of column names


# Import data
testData <- fread("./UCI HAR Dataset/test/X_test.txt", select = c(columnsVector)) # Imports only relevant columns
trainData <- fread("./UCI HAR Dataset/train/X_train.txt", select = c(columnsVector)) # Imports only relevant columns
subjectTest <- read.table("./UCI HAR Dataset/test/subject_test.txt") # Import subject list for test data
subjectTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt") # Import subject list for training data
labelsTest <- read.table("./UCI HAR Dataset/test/y_test.txt") #import labels
labelsTrain <- read.table("./UCI HAR Dataset/train/y_train.txt") # import labels

#Adding subjects and labels
testData <- add_column(testData, subjectTest[[1]], .before = 1) #adds subjects to data
trainData <- add_column(trainData, subjectTrain[[1]], .before = 1) #adds subjects to data
testData <- add_column(testData, labelsTest[[1]], .after = 1) #adds labels
trainData <- add_column(trainData, labelsTrain[[1]], .after = 1) #adds labels

#Adding readable variable names to data:
#Make column names readable
columnNames <- sub("^t", "time", columnNames); columnNames <- sub("^f", "freq", columnNames);
columnNames <- gsub("mean", "Mean", columnNames); columnNames <- gsub("std", "Std", columnNames);
columnNames <- gsub("-", "", columnNames); columnNames <- gsub("\\(\\)", "", columnNames)
#Define variable names
names(testData) <- c("subject", "activity", columnNames)
names(trainData) <- c("subject", "activity", columnNames)

#Making labels and activities readable
#Create variable for activities
activities <- read.table("./UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)
#Isolate labels, convert to lowercase and remove underscores
activities <- tolower(activities[[2]]); activities <- gsub("_", "", activities)
testData$activity <- as.factor(testData$activity); trainData$activity <- as.factor(trainData$activity) #converts activities to factors
## Assign labels as factors to activities column
levels(testData$activity) <- activities; levels(trainData$activity) <- activities

#Combine data
combinedData <- rbind(testData, trainData) #combine testing and training data to one table
combinedData <- group_by(combinedData, subject, activity) #group by subject and activity
avgData <- summarise_all(combinedData, funs(mean)) #new table containing only averages per subject and activity
avgNames <- capitalize(columnNames); avgNames <- paste("avg", avgNames, sep = "") #create variable names for avgData
names(avgData) <- c("subject", "activity", avgNames) #assign variable names
write.table(avgData, "./tidyData.txt", row.name = FALSE)