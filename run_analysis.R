library(data.table)
run_analysis <- function() {
  # The program re.organizes the data from the Human Activity Recognition Using Smartphones Dataset
  # Version 1.0 according to tidy data principles. The program does no take any arguments.
  # The program assumes that the data is downloaded from the source website and is extracted.
  # 
  # Source website: 
  #   https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
  #
  # Extracted directory structure:
  # Root
  # |-- UCI HAR Dataset -> files used: features.txt, activity_lables.txt
  #    |-- test -> files used: y_test.txt, x_test.txt, subject_test.txt
  #    |-- train -> files used: y_train.txt, x_train.txt, subject_train.txt
  # 
  # The program uses content of y_train.txt and y_test.txt and features.txt to create colum names. 
  # The file activity_lables.txt contains names of activities. The program replaces activity indexes 
  # with their names. Also it merges subject numbers with the data. Then it selects only data with 
  # mean() and std() values. Up to this point assignment steps 1-4 are completed. Finally data is 
  # aggregated by their mean value grouped by subject and activity and the result is written
  # into the file CourseProjectFinalData.txt and result is also returned to the caller.
  #
  
  # load data files into variables
  y_test          <- read.table("./UCI HAR Dataset/test/y_test.txt") 
  x_test          <- read.table("./UCI HAR Dataset/test/x_test.txt") 
  subject_test    <- read.table("./UCI HAR Dataset/test/subject_test.txt") 
  y_train         <- read.table("./UCI HAR Dataset/train/y_train.txt") 
  x_train         <- read.table("./UCI HAR Dataset/train/x_train.txt") 
  subject_train   <- read.table("./UCI HAR Dataset/train/subject_train.txt") 
  features        <- read.table("./UCI HAR Dataset/features.txt") 
  activity_lables <- read.table("./UCI HAR Dataset/activity_labels.txt")

  # takes two args:
  #   dataframe   -> column indexes in each row (y_test.txt, y_train.txt files)
  #   newrownames -> names of the columns in each row
  # result is a dataframe containig names of columns in each row in their order
  replaceIndexesWithNames <- function(dataframe,newrownames) {
    index <- nrow(newrownames)   
    for(n in 1:index) {
      dataframe[dataframe==as.integer(n)] <- as.character(newrownames[n,2])
    }
    dataframe
  }
  
  # takes two args:
  #   dataframe      -> dataset without colum names
  #   newcolumnnames -> names of the columns
  # result is a dataset with proper column names
  setColumnNames <- function(dataframe,newcolumnnames) {
    index <- ncol(dataframe)
    for(n in 1:index) {
      names(dataframe)[n] <- as.character(newcolumnnames[n,2])
    } 
    dataframe
  }
  
  # takes 5 args:
  #   x        -> 1 dataset (training or test)
  #   y        -> 1 dataset (training or test)
  #   features -> column names in the order of columns in x and y
  #   activity -> activity lables
  #   subject  -> subject number
  # returns full dataset of std() and mean() columns
  getFinalSet <- function(x,y,features,activity,subject) {
    x <- setColumnNames(x,features)
    y <- replaceIndexesWithNames(y,activity)
    names(y) <- "activity"
    names(subject) <- "subject"
    final <- as.data.table(cbind(subject,y,x))
    final <- final[,grep(".std.|.mean.|activity|subject",names(final)), with=FALSE]
    final
  }
  
  final_test <- getFinalSet(x_test,y_test,features,activity_lables,subject_test) # get test data
  final_train <- getFinalSet(x_train,y_train,features,activity_lables,subject_train) # get train data
  combined_mean_std <- rbind(final_test,final_train) # merge 2 datasets
  
  # aggregate the means of the data by subject and activity
  aggregate_mean_std <- aggregate(. ~ subject+activity,data = combined_mean_std,FUN=mean)
  
  # write data into file
  write.table(aggregate_mean_std,file="CourseProjectFinalData.txt",row.names=FALSE)
  
  # return aggregated data
  aggregate_mean_std
}
