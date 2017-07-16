# ProgrammingAssignment3
run_analysis.R is an R script used to process data from the study Human Activity Recognition Using Smartphones Data Set

## Study Abstract:
Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.

## Study Source:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Study Data:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
The following 8 data files should be extracted from the zipped study data and saved in the R working directory.
  1. activity_labels.txt
  2. features.txt
  3. test\subject_test.txt
  4. train\subject_train.txt
  5. test\X_test.txt
  6. train\X_train.txt
  7. test\y_test.txt
  8. train\y_train.txt

This script reads the data files, combines and processes them into tidy data, then exports the tidy data.
This script works with base R only - no external packages used.