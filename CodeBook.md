# CodeBook
## Getting and Cleaning Data Course Project 
***

The code on *run_analysis.R* can be utilized to tidy and process UCI's Human Activity Recognition Using Smartphones Data Set (available [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)). The following steps are performed, not in this particular order:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
    
Sourcing run_analysis.R will automatically download and unzip the dataset into the working directory. The processing functions will be automatically executed and will produce the output files on the working directory.

These tasks are performed by the functions *tidydata()* and *calcmeans()*. The steps on each of these functions are labeled with letters, i.e. "a)" and are described in detail here:

### Function *tidydata()* steps:
* a) Variable names are collected from the features.txt file and stored as *datanames*
* b) Data from the training and testing datasets is collected and merged together. The variables are assigned names from step a) and a column named 'type' is added to allow *train* and *test* data to be differentiated if necessary.
* c) The *train* and *test* datasets are merged together and stored as *databoth*
* d) The numeric codes for the activity names are replaces by descriptive names obtained from the activity_labels.txt file
* e) As the only variables of interest are those containing mean and standard deviation of the measurements, data for the remaining measurements is removed from the dataset.
* f) Variable names are cleared for better readability by replacing "-" for "." and removing the "()"
* g) The tidy dataset (*databoth*) is written to the file "merged_data.txt"

### Function *calcmeans()* steps:
* a) The 'type' variable is removed in order to not influence on the mean value calculation for each subject/activity
* b) Calculates column-wise means grouping values by subject and activity
* c) The mean values for tidy dataset (*datastats*) is written to the file "merged_data_means.txt"

Function *calcmeans()* is executed **after** function *tidydata()*.