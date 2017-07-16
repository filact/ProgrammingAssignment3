# run_analysis.R is an R script used to process data from the study Human Activity Recognition Using Smartphones Data Set
# Study Abstract: Human Activity Recognition database built from the recordings of 30 subjects performing activities
# of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.
# Study Source: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# Study Data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# The following 8 data files should be extracted from the zipped study data and saved in the R working directory.
#  1. activity_labels.txt
#  2. features.txt
#  3. test\subject_test.txt
#  4. train\subject_train.txt
#  5. test\X_test.txt
#  6. train\X_train.txt
#  7. test\y_test.txt
#  8. train\y_train.txt

# This script reads the data files, combines and processes them into tidy data, then exports the tidy data.
# This script works with base R only - no external packages used.

# START OF SCRIPT

# STEP 1 - Read raw data and store into data frames
# Descriptive data
activity_labels <- read.table("activity_labels.txt", header=FALSE, col.names = c("ActivityID","Activity"), stringsAsFactors = FALSE)
features <- read.table("features.txt", header=FALSE, stringsAsFactors = FALSE)
features2 <- features[,2] #Create vector for X data column names
# subject data
subject_test <- read.table("subject_test.txt", header=FALSE, col.names = "Subject", stringsAsFactors = FALSE)
subject_train <- read.table("subject_train.txt", header=FALSE, col.names = "Subject", stringsAsFactors = FALSE)
# y data
y_test <- read.table("y_test.txt", header=FALSE, col.names = "ActivityID", stringsAsFactors = FALSE)
y_train <- read.table("y_train.txt", header=FALSE, col.names="ActivityID", stringsAsFactors = FALSE)
# X data
X_test <- read.table("X_test.txt", header=FALSE, stringsAsFactors = FALSE)
X_train <- read.table("X_train.txt", header=FALSE, stringsAsFactors = FALSE)
# Add names to X data using features data
names(X_test) <- features2
names(X_train) <- features2

# STEP 2 - Extract only measurements on mean and standard deviation for each measurement
mean_std_measures <- features2[grepl("mean\\(\\)|std\\(\\)", features2)]
X_test <- X_test[,mean_std_measures]
X_train <- X_train[,mean_std_measures]

# STEP 3 - Combine subject, y, and X data together
data_test <- cbind(subject_test, y_test, X_test)
data_train <- cbind(subject_train, y_train, X_train)

# STEP 4 - Merge test and train data sets together
data_all <- rbind(data_test,data_train)

# STEP 5 - Match Activity description with ActivityID and tidy data_all further
data_all <- merge(activity_labels,data_all)
data_all <- data_all[,-1] #Remove ActivityID column

# STEP 6 - Summarize data_all means by Subject and Activity into another data frame
colcount <- length(data_all) #Store number of columns of data_all
data_mean <- aggregate(data_all[,3:colcount], by=list(data_all[,1], data_all[,2]), mean) #Use aggregate function to get means
names(data_mean) <- c("Activity", "Subject", names(data_mean[3:colcount])) #Rename 1st and 2nd columns of data_mean 

# STEP 7 - Tidy data further

activity_subject <- data_mean[,1:2] #Extract activity and subject columns
stack_measures <- stack(data_mean[,3:colcount]) #Stack all measure columns into a single vector
# Combine activity, subject, and stacked measures into data frame, note that activity and subject are repeated
data_mean2 <- cbind(activity_subject,stack_measures)
# Create 2 columns listing the 1) Measure and 2) Mean/Standard Deviation of the Measure
mean_std <- cbind(gsub("-std\\(\\)","",gsub("-mean\\(\\)","",data_mean2[,4])), #Remove -mean() and -std() from the name
            ifelse(grepl("mean",data_mean2[,4])==TRUE,"mean",ifelse(grepl("std",data_mean2[,4])==TRUE,"std",""))) #Label mean/std
# Combine the Activity, Subject, Measure, Mean/Standard Deviation, and Measure Value columns and rename them
data_mean3 <- cbind(data_mean2[,1:2],mean_std,data_mean2[,3])
names(data_mean3) <- c("Activity", "Subject","Measure","MeanStd","Value")
# Split the data frame by Mean/Standard Deviation
data_mean3_split <- split(data_mean3[,-4],data_mean3$MeanStd, drop=TRUE)
# Combine the split Mean and Standard Deviation columns (with Activity, Subject, and Measure)
data_mean_final <- cbind(data_mean3_split$mean,data_mean3_split$std[,4])
# Rename the columns in the final data
names(data_mean_final) <- c("Activity", "Subject","Measure","Mean","StandardDeviation")

# STEP 8 - Export final data into csv
write.table(data_mean_final, "tidy_data_final.txt", row.names = FALSE)
# View final data table
View(data_mean_final)

# END OF SCRIPT