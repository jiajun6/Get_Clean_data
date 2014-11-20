# CodeBook for this project

## Context

Data was collected by a group of researchers to analyze the possibility of using smartphones with embedded inertial sensors to assess human activity. The experiment was done with 30 subjects carrying the smartphones, who were video-recorded while performing one among six activities (walking, walking upstairs, walking downstairs, sitting, standing, laying). Three-axial linear acceleration and 3-axial angular velocity were measured with the inertial sensors during activities. The sensor signals were pre-processed (i.e., noise filtering, time window sampling) and 561 features from time and frequency domains were calculated for each activity performed by each subject. The data set was randomly partitioned into a training set (70% of the subjects) and a testing set (30% of the subjects). The data files were made available for further analysis on the UCI Machine Learning Repository. In order to be able to analyze that data, one needs to assemble the various parts that are contained in separate files (i.e., measurements, features, activities, subjects). More details on the experiment and the data can be found at the following address:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

## Objectives

The objective of this project was to first assemble the different files to compose a data set according to the specifications listed below, and to create a second data set containing the average values of selected features for each activity and each subject. The specifications included:
- merging the training and testing data;
- selecting only features corresponding to the mean and standard deviation of each measurement;
- using descriptive labels to identify selected features;
- using the appropriate label to identify activities.


## Data source

The files were downloaded using this URL:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The following unzipped files were used:
- features.txt: labels for the 561 features - 561 * 2 (feature # and label);
- activity_labels.txt: six activity labels - 6 * 2 (activity code and label));
- train/x_train.txt: training data (7352 observations * 561 features);
- train/y_train.txt: activity code corresponding to each observation of the training set (7352 * 1);
- train/subject_train.txt: subject id for training set (21 values between 1 and 30); 
- test/x_test.txt: testing data (2947 observations * 561 features);
- test/y_test.txt: activity code corresponding to each observation of the testing set (2947 * 1);
- test/subject_test.txt: subject id for testing set (9 values between 1 and 30, not found in train/subject_train.txt); 

## Methods

After reading all data files into R, the following steps were followed (see the run_analysis.R script in the same repo).

### 1. Selection of features 

The required features were first selected. The initial names of the features found in features.txt helped identifying the variables and the mathematical treatment applied on it.

There was a total of 33 variables (for variables ending with XYZ, there was one variable for each axis): 
- tBodyAcc-XYZ
- tGravityAcc-XYZ
- tBodyAccJerk-XYZ
- tBodyGyro-XYZ
- tBodyGyroJerk-XYZ
- tBodyAccMag
- tGravityAccMag
- tBodyAccJerkMag
- tBodyGyroMag
- tBodyGyroJerkMag
- fBodyAcc-XYZ
- fBodyAccJerk-XYZ
- fBodyGyro-XYZ
- fBodyAccMag
- fBodyAccJerkMag
- fBodyGyroMag
- fBodyGyroJerkMag

There were 16 possible treatments done:
- mean(): Mean value
- std(): Standard deviation
- mad(): Median absolute deviation 
- max(): Largest value in array
- min(): Smallest value in array
- sma(): Signal magnitude area
- energy(): Energy measure. Sum of the squares divided by the number of values. 
- iqr(): Interquartile range 
- entropy(): Signal entropy
- arCoeff(): Autoregression coefficients with Burg order equal to 4
- correlation(): correlation coefficient between two signals
- maxInds(): index of the frequency component with largest magnitude
- meanFreq(): Weighted average of the frequency components to obtain a mean frequency
- skewness(): skewness of the frequency domain signal 
- kurtosis(): kurtosis of the frequency domain signal 
- bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.

In the 561 features, there were also four fields representing angle between vectors.

Each of the 561 field names contained information on the variable and on the treatment. For example, the variable tBodyAcc-mean()-X represented the mean of the tBodyAcc along the X axis. For this project, we were only interested by the mean() and standard deviation (std()). 

The str_detect functions from the stringr package was then used to identify all features that contained either the string mean() or the string std(). 66 features contained one or the other. This was used to compose a logical vector to be able to subset the whole measurement data set in a subsequent step.

### 2. Prepare training and testing subsets 

Relevant columns were selected from the training table created from the basic file (X_train.txt), using the logical vector created in step 1. Then the vector representing the ids of the subjects (from subject_train.txt) was column-bound to that subset. The activity code vector (from y_train.txt) was then column-bound to that subset.

The same operations were performed with the testing tables from X_test.txt, subject_train.txt and y_train.txt files.

### 3. Merge training and testing sets and identify activities

The training and testing subsets produced in step 2 were merged together using row binding, which produced a data table of 10299 rows by 68 columns. The last operation consisted of retrieving the activity label corresponding to the activity code for each observation. This was done using the merge function applied on the activity column. The activity code column was then removed from this new table (df_alldata).

### 4. Calculate the average of each selected feature for each subject and each activity

A table was created by sub-grouping the df_alldata table, using the group_by function of the dplyr package. It was grouped by subject and activity. Then the mean function was applied to each sub-group using the summarise_each function and the results were assigned to a new table called stats_subj_act. This resulting table was then exported to the stats_subj_act.txt file.


## Description of the final file (stats_subj_act.txt file)

The final file contains 68 variables and 181 lines. The data in each line is space delimited. The first line contains the headers with "". The other 180 lines contain the data: identification of the subject (1 to 30), activity (one of six possibilities), and the average values of the 66 selected measurement features. The 68 variable names are listed below. Only two of the 66 measurement features are described; the same logic applies to all 64 other features.

- subject: id of the experiment subject (1 to 30)
- activity: name of the activity (walking, walking upstairs, walking downstairs, sitting, standing, laying)
- tBodyAcc_mean_X: average of the mean of the tBodyAcc along the X axis for a given subject and activity
- tBodyAcc_mean_Y
- tBodyAcc_mean_Z
- tBodyAcc_std_X: average of the standard deviation of the tBodyAcc along the X axis for a given subject and - activity
- tBodyAcc_std_Y
- tBodyAcc_std_Z
- tGravityAcc_mean_X
- tGravityAcc_mean_Y
- tGravityAcc_mean_Z
- tGravityAcc_std_X
- tGravityAcc_std_Y
- tGravityAcc_std_Z
- tBodyAccJerk_mean_X
- tBodyAccJerk_mean_Y
- tBodyAccJerk_mean_Z
- tBodyAccJerk_std_X
- tBodyAccJerk_std_Y
- tBodyAccJerk_std_Z
- tBodyGyro_mean_X
- tBodyGyro_mean_Y
- tBodyGyro_mean_Z
- tBodyGyro_std_X
- tBodyGyro_std_Y
- tBodyGyro_std_Z
- tBodyGyroJerk_mean_X
- tBodyGyroJerk_mean_Y
- tBodyGyroJerk_mean_Z
- tBodyGyroJerk_std_X
- tBodyGyroJerk_std_Y
- tBodyGyroJerk_std_Z
- tBodyAccMag_mean
- tBodyAccMag_std
- tGravityAccMag_mean
- tGravityAccMag_std
- tBodyAccJerkMag_mean
- tBodyAccJerkMag_std
- tBodyGyroMag_mean
- tBodyGyroMag_std
- tBodyGyroJerkMag_mean
- tBodyGyroJerkMag_std
- fBodyAcc_mean_X
- fBodyAcc_mean_Y
- fBodyAcc_mean_Z
- fBodyAcc_std_X
- fBodyAcc_std_Y
- fBodyAcc_std_Z
- fBodyAccJerk_mean_X
- fBodyAccJerk_mean_Y
- fBodyAccJerk_mean_Z
- fBodyAccJerk_std_X
- fBodyAccJerk_std_Y
- fBodyAccJerk_std_Z
- fBodyGyro_mean_X
- fBodyGyro_mean_Y
- fBodyGyro_mean_Z
- fBodyGyro_std_X
- fBodyGyro_std_Y
- fBodyGyro_std_Z
- fBodyAccMag_mean
- fBodyAccMag_std
- fBodyBodyAccJerkMag_mean
- fBodyBodyAccJerkMag_std
- fBodyBodyGyroMag_mean
- fBodyBodyGyroMag_std
- fBodyBodyGyroJerkMag_mean
- fBodyBodyGyroJerkMag_std

 




