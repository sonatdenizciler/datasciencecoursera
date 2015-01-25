# run_analysis.R

## Version 1.0

Author: Sonat Denizciler
Email: sonat@rocketmail.com
================================================================================================================================
The program reorganizes the data from the Human Activity Recognition Using Smartphones Dataset Version 1.0 according to tidy data principles. The program does no take any arguments. The program assumes that the data is downloaded from the source website and is extracted.
 
Source website: 
   https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

 Extracted directory structure:
 
 [home]
 
 |-- UCI HAR Dataset -> files used: features.txt, activity_lables.txt
 
    |-- test -> files used: y_test.txt, x_test.txt, subject_test.txt
    
    |-- train -> files used: y_train.txt, x_train.txt, subject_train.txt
 
 
The Program must be run from the root directory. "home" is the directory where you extract the data that is to be processed. The program uses content of y_train.txt and y_test.txt and features.txt to create colum names. The file activity_lables.txt contains names of activities. The program replaces activity indexes with their names. Also it merges subject numbers with the data. Then it selects only data with mean() and std() values. Up to this point assignment steps 1-4 are completed. Finally data is aggregated by their mean value grouped by subject and activity and the result is written into the file CourseProjectFinalData.txt and result is also returned to the caller.
