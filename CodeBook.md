Getting and Cleaning Data - peer assessment project
The original data was transformed by
1.	Merging the training and the test sets to create one data set.
2.	Extracting only the measurements on the mean and standard deviation for each measurement.
3.	Using descriptive activity names to name the activities in the data set
4.	Appropriately labeling the data set with descriptive activity names.
5.	Creating a second, independent tidy data set with the average of each variable for each activity and each subject.
About R script
File with R code "run_analysis.R" performs above 5 steps (in accordance assigned task of course work)

About the original files and the new data sets:

Following were the eight downloaded files:

1.	Training data:

i)	x_train 
ii)	y_train 
iii)	subject_train 

2.	Testing data:

iv)	x_test 
v)	y_test 
vi)	subject_test 

3.	 Activity labels:

vii)	activity_labels

4.	 Feature vector:

viii)	features 

Merging the training and the test sets to create one data set called allData for further analysis.

Replace un-intuitive column names by intuitive (descriptive) one:

•	As the rows of features file contains the correct names for the x_data and y_data sets, so we replaced the column names of
x_data and y_data with these features.
