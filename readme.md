# Repository for Getting and Cleaning data course project

## Description

This project consisted of first assembling different files that were downloaded from the UCI Machine Learning Repository. The main file contained data that was collected by a group of researchers to analyze the possibility of using smartphones with embedded inertial sensors to assess human activity. The experiment was done with 30 subjects carrying the smartphones, who were video-recorded while performing one among six activities (walking, walking upstairs, walking downstairs, sitting, standing, laying). Three-axial linear acceleration and 3-axial angular velocity were measured with the inertial sensors during activities. The sensor signals were pre-processed (i.e., noise filtering, time window sampling) and 561 features from time and frequency domains were calculated for each activity performed by each subjects. 

The tidy data set produced in this project had to contain the average of many features selected from the downloaded files, based on pre-determined criteria. Details on the data set, the selection criteria and the procedure that was followed are provided in the CodeBook.md file. 

## Content

- CodeBook.md: provides details on the source of the data, and the different operations performed on the data to produce the final tidy set.
- run_analysis.R: the R script that was developed to process the data and produce the final data set, following the procedure described in the CodeBook.md file.
- stats_subj_act_txt: a file that contains the final tidy data set (average values of selected features by subject and activity level).



