
# Course Project for the course Getting and Cleaning Data - File name run_analysis.R

# One of the most exciting areas in all of data science right now is wearable computing
# - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are 
# racing to develop the most advanced algorithms to attract new users. The data linked
# to from the course website represent data collected from the accelerometers from the
# Samsung Galaxy S smartphone. A full description is available at the site where the 
# data was obtained:

# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

# Here are the data for the project:

# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

# Here we are creating one R script called run_analysis.R that does the following.

# 1.	Merges the training and the test sets to create one data set.
# 2.	Extracts only the measurements on the mean and standard deviation for each 
#     measurement. 
# 3.	Uses descriptive activity names to name the activities in the data set
# 4.	Appropriately labels the data set with descriptive variable names. 
# 5.	From the data set in step 4, creates a second, independent tidy data set with
#     the average of each variable for each activity and each subject.

# Solution

# 1.	Let us merge the training and the test sets to create one data set called allData.

rm(list = ls()) # To start afresh

setwd("E:/Coursera/03 Getting and Cleaning Data/Peer-graded Assignment")

if(!file.exists("./dataProj")){dir.create("./dataProj")}

# Let us download the data for the project:

activity_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(activity_url, destfile="./dataProj/dataSet.zip")

# Unzip dataSet to /dataProj directory

unzip(zipfile="./dataProj/dataSet.zip",exdir="./dataProj")

# Let us first read trainings data:

x_train <- read.table("./dataProj/UCI HAR Dataset/train/X_train.txt")

y_train <- read.table("./dataProj/UCI HAR Dataset/train/y_train.txt")

subject_train <- read.table("./dataProj/UCI HAR Dataset/train/subject_train.txt")

# We next read testing data:

x_test <- read.table("./dataProj/UCI HAR Dataset/test/X_test.txt")

y_test <- read.table("./dataProj/UCI HAR Dataset/test/y_test.txt")

subject_test <- read.table("./dataProj/UCI HAR Dataset/test/subject_test.txt")

# Let us read activity labels as well:

activitylabels = read.table('./dataProj/UCI HAR Dataset/activity_labels.txt')

# Next reading feature vector:

features <- read.table('./dataProj/UCI HAR Dataset/features.txt')

# Exploring these eight objects

class(x_train)   # "data.frame"
dim(x_train)     # 7352  561
head(x_train,1)  # V1, V2, ..., V561 columns

class(y_train)   # "data.frame"
dim(y_train)     # 7352  1
head(y_train,1)  # V1 column

class(subject_train)   # "data.frame"
dim(subject_train)     # 7352  1
head(subject_train,1)  # V1 column

class(x_test)   # "data.frame"
dim(x_test)     # 2947  561
head(x_test,1)  # V1, V2, ..., V561 columns

class(y_test)   # "data.frame"
dim(y_test)     # 2947  1
head(y_test,1)  # V1 column

class(subject_test)   # "data.frame"
dim(subject_test)     # 2947  1
head(subject_test,1)  # V1 column

class(activitylabels)   # "data.frame"
dim(activitylabels)     # 6 2
head(activitylabels)    # V1 V2 columns

#  V1                 V2
#1  1            WALKING
#2  2   WALKING_UPSTAIRS
#3  3 WALKING_DOWNSTAIRS
#4  4            SITTING
#5  5           STANDING
#6  6             LAYING

class(features)   # "data.frame"
dim(features)     # 561 2
head(features)    # V1 V2 columns

#  V1                V2
#1  1 tBodyAcc-mean()-X
#2  2 tBodyAcc-mean()-Y
#3  3 tBodyAcc-mean()-Z
#4  4  tBodyAcc-std()-X
#5  5  tBodyAcc-std()-Y
#6  6  tBodyAcc-std()-Z

# Let us replace un-intuitive column names by intuitive (descriptive) one:

colnames(x_train) <- features[,2]  # 561 features are now the column names of x_train
colnames(y_train) <-"actId"        # The only column of y_train is now called "actId"
colnames(subject_train) <- "subId" # The only column of subject_train is now called
                                   # "subId"

# It makes sense that both testing and training data should having identical column names

colnames(x_test) <- colnames(x_train) 
colnames(y_test) <- colnames(y_train)
colnames(subject_test) <- colnames(subject_train) 

# Same sprit of assigning intuitive (descriptive) names to the columns of activitylabels

colnames(activitylabels) <- c('actId','actType')

# Let us combine all data frames in one data frame:

trainData <- cbind(y_train, subject_train, x_train)  #  7352 by 563

testData <- cbind(y_test, subject_test, x_test)      #  2947 by 563

allData <- rbind(trainData, testData)                # 10299 by 563

# 2.	Let us extracts only the measurements on the mean and standard deviation for each 
#     measurement.

# We first have a header vector consisting of actId field, subId field, and all 
# those fields containing mean and standard deviation:

meanStd <- (grepl("\\<actId\\>|\\<subId\\>|\\<mean()\\>|\\<std()\\>", colnames(allData)))
# this one will not include fields containing "meanFreq()" in it 

meanStd <- (grepl("actId|subId|mean()|std()", colnames(allData)))
# this one will also include fields containing "meanFreq()" in it 

# Let us have required subset from allData:

meanAndStdData <- allData[, meanStd == TRUE]

names(meanAndStdData)
dim(meanAndStdData)

# 3. Uses descriptive activity names to name the activities in the data set

activityNamesData <- merge(meanAndStdData, activitylabels, by = 'actId', all.x = TRUE)

names(activityNamesData)

# 4. Appropriately labels the data set with descriptive variable names. 
# Labels in part 1, 2 and 3 are, respectively allData, meanAndStdData and activityNamesData

# 5. From the data set in step 4, creates a second, independent tidy data set with
#    the average of each variable for each activity and each subject.

tidyDataSet <- aggregate(. ~subId + actId, activityNamesData, mean)

tidyDataSet <- tidyDataSet[order(tidyDataSet$subId, tidyDataSet$actId),]

# Finally write tidyDataSet as txt file

write.table(tidyDataSet, "./dataProj/UCI HAR Dataset/tidyDataSet.txt", row.name=FALSE)

# In case you like to write tidyDataSet as csv file

write.csv(tidyDataSet, "./dataProj/UCI HAR Dataset/tidyDataSet.csv")



