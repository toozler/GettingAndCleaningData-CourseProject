# Getting and Cleaning Data (getdata-030) 
# Course Project Submission

# tidydata() and calcmeans()
# refer to CodeBook.md for further description for each processing step identified by letters a) to g)


# tidydata() : Merges and labeling datasets
tidydata <- function() {

    # a)
    ## Fetching variable names from features.txt
    datanames <- read.table("./UCI HAR Dataset/features.txt", colClasses = c("numeric","character"))[,2]
    datanames <- tolower(datanames)

    # b)
    ## Reading the training data (values, subject, and activity code) and merging the columns
    ## A column 'type' is introduced to identify if the values are from the test or train datasets
    x <- read.table("./UCI HAR Dataset/train/X_train.txt")
    y <- read.table("./UCI HAR Dataset/train/y_train.txt")
    s <- read.table("./UCI HAR Dataset/train/subject_train.txt")
    datatrain <- cbind(rep("train",nrow(y)),s,y,x)
    names(datatrain) <- c("type","subject","activity",datanames)

    ## Reading the testing data ((values, subject, and activity code) and merging the columns
    ## A column 'type' is introduced to identify if the values are from the test or train datasets
    x <- read.table("./UCI HAR Dataset/test/X_test.txt")
    y <- read.table("./UCI HAR Dataset/test/y_test.txt")
    s <- read.table("./UCI HAR Dataset/test/subject_test.txt")
    datatest <- cbind(rep("test",nrow(y)),s,y,x)
    names(datatest) <- c("type","subject","activity",datanames)

    # c)
    ## Merging testing and training data
    ## They are still discernible via the 'type' column
    databoth <- rbind(datatrain,datatest)

    # d)
    ## Applying descriptive labels to the activity names
    datadesc <- read.table("./UCI HAR Dataset/activity_labels.txt", colClasses = c("numeric","character"))
    for (i in datadesc[,1]) { databoth$activity <- as.factor(gsub(i, tolower(datadesc[i,2]), databoth$activity)) }

    # e)
    ## Removing unwanted variables retaining only those containing mean and standard deviation measurements,
    ## plus the type (train/test), subject (#) and activity (e.g. walking, sitting, ...) 
    keep <- c("type","subject","activity",grep("mean\\(\\)|std\\(\\)",datanames, value=TRUE))
    databoth <<- databoth[keep]

    # f)
    ## Cleaning variable names before writing tidy file
    names(databoth) <- gsub("-",".",names(databoth))
    names(databoth) <- gsub("\\(\\)","",names(databoth))

    # g)
    ## Writes tidy dataset into file
    write.table(databoth, "merged_data.txt", row.names=FALSE)
}


## calcmeans() : Calculates means for each variable grouped by activity and subject
calcmeans <- function() {
    library(plyr)
  
    # a) 
    ## Removing the 'type' variable previously introduced
    keep <- c("subject","activity",grep("mean|std",names(databoth), value=TRUE))
    databoth <- databoth[keep]
    
    # b)
    ## Calculates colum-wise means grouping values by subject and activity
    datastats <<- ddply(databoth, .(subject, activity), colwise(mean))
    
    # c)
    ## Writes tidy dataset into file
    write.table(datastats, "merged_data_means.txt", row.names=FALSE)
}


# Dowloading and unzipping dataset into "UCI HAR Dataset" folder
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile="dataset.zip", method="curl")
unzip("dataset.zip")


# Executing functions
tidydata()
calcmeans()
