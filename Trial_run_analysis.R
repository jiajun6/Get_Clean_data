setwd("C:/DataProjects/R/RprogCourse/UCI HAR Dataset")
library(data.table)
library(stringr)
library(dplyr)
library(sqldf)

## Instructions provided:
## This script has to do the following:
## 1.Merges the training and the test sets to create one data set.
## 2.Extracts only the measurements on the mean and standard deviation
##   for each measurement. 
## 3.Uses descriptive activity names to name the activities in the data set
## 4.Appropriately labels the data set with descriptive variable names. 
## 5.From the data set in step 4, creates a second, independent tidy 
## data set with the average of each variable for each activity 
## and each subject.

# Structure of data sets first overviewed using Excel
# features.txt: contains labels for the 561 features (561 rows * 2 cols (column # + label))
# activity_labels.txt: contains activity labels (6 rows * 2 cols (activity # + label))
# traing sets have 7352 rows; testing sets have 2947 rows: total of 10299 rows
# train/x_train.txt contains the training data (7352* 561)
# train/y_train.txt contains activity labels (7352 * 1)
# train/subject_train.txt: contains subject # (21 values between 1 and 30; 
# the test equivalent contains 9 values for a total of 30 subjects0)

# Use colnames for binding measures with feature names
# keep only relevant row (means, etc.)
# use keys to bond rows with activity and subject


### Prepare names of columns

# Load labels for field names

arr_field_names <- read.table("features.txt", header = FALSE, sep = " ") # ,nrows = 10)
field_names <- as.character(arr_field_names[,2]) # if we omit as.character, it create a factor var

# identify field names with 'mean()' and 'std()' inside

str_mean <- "mean()"
col_mean <- str_detect(field_names,fixed(str_mean))
length(col_mean)
sum(col_mean)  # 33 occurences; use fixed(pattern) to match the exact pattern

str_std <- "std()"
col_std <- str_detect(field_names,fixed(str_std))
length(col_std)
sum(col_std) # 33 occurences

col_all <- (col_mean | col_std)
length(col_all)
sum(col_all) # 66 columns

# Keep only relevant field names and assign to kept_field_names array

tmp_kept_names <- field_names[col_all]
length(tmp_kept_names)

tmp2_kept_names <- str_replace_all(tmp_kept_names, "-","_")

kept_field_names <- str_replace_all(tmp2_kept_names,"\\()","")
kept_field_names

### Identify subjects

# Subjects in training file 

df_train_subjects <- read.table("train/subject_train.txt", header = FALSE, sep = "")
dim(df_train_subjects) # 7352 rows, 1 column
table(df_train_subjects)
length(table(df_train_subjects)) # 21 different subjects
head(df_train_subjects,20)
colnames(df_train_subjects) <- "subject"
summary(df_train_subjects)

df_test_subjects <- read.table("test/subject_test.txt", header = FALSE, sep = "")
dim(df_test_subjects) # 2947 rows, 1 column
table(df_test_subjects)
length(table(df_test_subjects)) # 9 different subjects
colnames(df_test_subjects) <- "subject"

## Read activity labels

df_labels <- read.table("activity_labels.txt",header = FALSE, sep = "") #,nrows = 10) # colClasses = "character")
colnames(df_labels) <- c("activity_cd", "activity")
df_labels

# Read activity files 

dfy_train <- read.table("train/y_train.txt",header = FALSE, sep = "") #,nrows = 10) # colClasses = "character")
colnames(dfy_train) <- "activity_cd"
str(dfy_train)

dfy_test <- read.table("test/y_test.txt",header = FALSE, sep = "") #,nrows = 10) # colClasses = "character")
colnames(dfy_test) <- "activity_cd"
str(dfy_test)


### Read x training file (measurements)

# df_train <- read.csv("train/X_train.txt", header = FALSE, sep = " ",nrows = 10)
dfx_train <- read.table("train/X_train.txt", header = FALSE, sep = "") #,nrows = 10)
# does not work: x2_train <- fread("train/X_train.txt", nrows = 10)
dim(dfx_train)
# print(dfx_train[1:5,1:5])

# Extract relevant columns and assign column names

x_train <- dfx_train[,col_all]
dim(x_train)
colnames(x_train) <- kept_field_names
str(x_train)

# attach training subject column (column binding)

x2_train <- cbind(df_train_subjects, x_train)
dim(x2_train)

# attach training activity code column (column binding)

x3_train <- cbind(dfy_train, x2_train)
dim(x3_train)
str(x3_train)
table(x3_train$activity_cd,x3_train$subject)

### Read x testing file (measurements)

dfx_test <- read.table("test/X_test.txt", header = FALSE, sep = "") # , nrows = 10)
dim(dfx_test)

# keep only selected columns (mean and std)
x_test <- dfx_test[,col_all]
dim(x_test)
colnames(x_test) <- kept_field_names
print(x_test[1:5,1:5])

# attach testing subject column (column binding)

x2_test <- cbind(df_test_subjects, x_test)
dim(x2_test)
print(x2_test[1:5,1:5])

# attach testing activity code column (column binding)

x3_test <- cbind(dfy_test, x2_test)
dim(x3_test)
print(x3_test[1:5,1:5])
table(x3_test$activity_cd,x3_test$subject)


### Merge the training and test files (row binding)

x_alldata <- rbind(x3_train, x3_test)
dim(x_alldata)
str(x_alldata)
table(x_alldata$subject, x_alldata$activity_cd)

### Associate activity labels to all records

df_alldata <- merge(x_alldata,df_labels)
dim(df_alldata)
table(df_alldata$subject, df_alldata$activity_cd)


### Remove activity_cd column 

df_alldata <- subset(df_alldata, select = -activity_cd)


### Do stats using dplyr package

by_subj_act <- group_by(df_alldata, subject,activity)
stats_subj_act <- summarise_each(by_subj_act, funs(mean))
stats_subj_act <- arrange(stats_subj_act, subject, activity)

### Write data to text file

write.table(stats_subj_act, file = "stats_subj_act.txt", row.name=FALSE)

