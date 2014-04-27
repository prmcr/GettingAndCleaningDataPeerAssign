The data available from the course website is used as the raw data. All the processing that was done on the data is part of the run_analysis.R script. No additional processing was done.

The scripts expects an unzipped directory "UCI HAR Dataset" to be present in the current directory.

The data in "Inertial Signals/" directory of train and test are not required for the purposes of "tidy" data and hence are not touched during the cleaning process.

test.data, train.data and merged.data variables have the tidy datasets. The tidy datasets have 3 additional columns apart from the 561 feature columns. The additional ones are "ActivityID", "ActivityDescription" and "SubjectID". 

new.data has the independent tidy data set with the average of each variable for each activity and each subject. 

