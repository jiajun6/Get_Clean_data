## By R.Lacroix
## Nov 19, 2014

## This script does the following:
## 1.Reads all required files from the Human Activity Recognition project
##  trainingactivity labels,)
## 2.Extracts only the measurements on the mean and standard deviation
##   for each measurement. 
## 3.Uses descriptive activity names to name the activities in the data set
## 4.Appropriately labels the data set with descriptive variable names. 
## 5.From the data set in step 4, creates a second, independent tidy 
## data set with the average of each variable for each activity 
## and each subject.


### Identify required columns and prepare column names

# Load labels for column names (feature.txt)

arr_field_names <- read.table("features.txt", header = FALSE, sep = " ") # ,nrows = 10)
field_names <- as.character(arr_field_names[,2]) # if we omit as.character, it create a factor var

# Identify column with 'mean()' and 'std()' from list of features

str_mean <- "mean()"
col_mean <- str_detect(field_names,fixed(str_mean))

str_std <- "std()"
col_std <- str_detect(field_names,fixed(str_std))

col_all <- (col_mean | col_std)

# Keep only relevant field names and assign to kept_field_names array

tmp_kept_names <- field_names[col_all]
tmp2_kept_names <- str_replace_all(tmp_kept_names, "-","_")
kept_field_names <- str_replace_all(tmp2_kept_names,"\\()","")


### Load data to identify subjects associated with measurements (training and testing sets)

# Subjects in training file 

df_train_subjects <- read.table("train/subject_train.txt", header = FALSE, sep = "")
colnames(df_train_subjects) <- "subject"

# Subjects in testing file

df_test_subjects <- read.table("test/subject_test.txt", header = FALSE, sep = "")
colnames(df_test_subjects) <- "subject"


## Read activity data files

# Activity labels

df_labels <- read.table("activity_labels.txt",header = FALSE, sep = "") #,nrows = 10) # colClasses = "character")
colnames(df_labels) <- c("activity_cd", "activity")

# Training activity file 

dfy_train <- read.table("train/y_train.txt",header = FALSE, sep = "") #,nrows = 10) # colClasses = "character")
colnames(dfy_train) <- "activity_cd"

# Training activity file 

dfy_test <- read.table("test/y_test.txt",header = FALSE, sep = "") #,nrows = 10) # colClasses = "character")
colnames(dfy_test) <- "activity_cd"


### Read measurement training file, add column namesn and add subject and activity columns

# Read measurements

dfx_train <- read.table("train/X_train.txt", header = FALSE, sep = "")

# Extract relevant columns and assign column names

x_train <- dfx_train[,col_all]
colnames(x_train) <- kept_field_names

# Attach training subject column (column binding)

x2_train <- cbind(df_train_subjects, x_train)

# Attach training activity code column (column binding)

x3_train <- cbind(dfy_train, x2_train)


### Read measurement testing file

# Read measurements

dfx_test <- read.table("test/X_test.txt", header = FALSE, sep = "") # , nrows = 10)

# Extract relevant columns and assign column names

x_test <- dfx_test[,col_all]
colnames(x_test) <- kept_field_names

# Attach testing subject column (column binding)

x2_test <- cbind(df_test_subjects, x_test)

# Attach testing activity code column (column binding)

x3_test <- cbind(dfy_test, x2_test)


### Merge the training and test files (row binding)

x_alldata <- rbind(x3_train, x3_test)


### Associate activity labels to all records

df_alldata <- merge(x_alldata,df_labels)


### Remove activity_cd column 

df_alldata <- subset(df_alldata, select = -activity_cd)


### Create subgroups of data based on activity and subject, and calculate average for each column

by_subj_act <- group_by(df_alldata, subject,activity)
stats_subj_act <- summarise_each(by_subj_act, funs(mean))
stats_subj_act <- arrange(stats_subj_act, subject, activity)

### Write data to text file

write.table(stats_subj_act, file = "stats_subj_act.txt", row.name=FALSE)

