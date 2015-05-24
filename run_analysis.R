tidyDataset <- function(download = FALSE) {

  # The <<- is used to make the variable global, thus accessible to all the other functions that will be called
  features <<- "./UCI HAR Dataset/features.txt"
  activity_labels <<- "./UCI HAR Dataset/activity_labels.txt"
  x_train <<- "./UCI HAR Dataset/train/X_train.txt"
  y_train <<- "./UCI HAR Dataset/train/y_train.txt"
  subject_train <<- "./UCI HAR Dataset/train/subject_train.txt"
  x_test  <<- "./UCI HAR Dataset/test/X_test.txt"
  y_test  <<- "./UCI HAR Dataset/test/y_test.txt"
  subject_test <<- "./UCI HAR Dataset/test/subject_test.txt"

  environmentReady = FALSE
  environmentReady = checkPackages()
  if(environmentReady) {
    message("Required packages are installed.")
    environmentReady = FALSE

    #If the user has asked to download the dataset automatically, download the zip, unzip it and remove it from the system
    if(download) {
        download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "dataFile.zip",  mode="wb", quiet=FALSE)
        unzip("dataFile.zip")
        file.remove("dataFile.zip")
    }
    #Check the existence of the dataset as specified in the README; if a file exists file.access returns 0
    environmentReady <- file.access(c(features, activity_labels, x_train, y_train, subject_train, x_test, y_test, subject_test))
    environmentReady <- isTRUE(all.equal( max(environmentReady) ,min(environmentReady))) && environmentReady[1] == 0
    if(environmentReady) {
      message("Required files are present.")
      # 1) After the download of the file, load the datasets into memory
      loadDataset()
      # 2) Merging the training and the test dataset to create a unique dataset on which to work upon
      merged <- mergeDatasets()
      # 3) Filtering by retrieving only mean and standard deviation on the overall dataset, keeping the Subject id and the ActivityId
      filteredSensor <- filterMerged(merged)
      # 4) Change the labels in the dataset in a human readable format
      filteredSensor <- refactorNames(filteredSensor)
      # 5) Creating a second, independent tidy data set with the average of each variable for each activity and each subject.
      writeTidy(filteredSensor)
    }
    else
      stop('The required dataset files are not present in the system')
  }
  else
    stop('The required packages are not present in the system')
}


#Function used to automatically download and install the required packages. If the packages are not installed
#and the user choose not to install them, the script will exit gracefully
checkPackages <- function() {
  suppressWarnings({
    if (!require(plyr)) {
        installPackage <- readline(paste("Package plyr not found. Install? (y for yes, anything else to abort) "))
        if (installPackage == "y") {
          install.packages("plyr")
          require(plyr)
        }
        else
          return(FALSE)
    }

    if (!require(utils)) {
        installPackage <- readline(paste("Package utils not found. Install? (y for yes, anything else to abort) "))
        if (installPackage == "y") {
          install.packages("utils")
          require(utils)
        }
        else
          return(FALSE)
    }

    return(TRUE)
  })
}


loadDataset <- function() {
  # Loading data from the dataset
  #colClasses is set as "character" to suppress all conversions
  features <<- read.table(features, colClasses = c("character"))
  activity_labels <<- read.table(activity_labels, col.names = c("ActivityId", "Activity"))
  x_train <<- read.table(x_train)
  y_train <<- read.table(y_train)
  subject_train <<- read.table(subject_train)
  x_test <<- read.table(x_test)
  y_test <<- read.table(y_test)
  subject_test <<- read.table(subject_test)
  message("Loaded datasets.")
}

mergeDatasets <- function() {
  # Merging together the training datasets by column, thus adding all the features that were split into several files in a unique one
  training <- cbind(cbind(x_train, subject_train), y_train)
  # Merging together the test datasets, thus adding all the features that were split into several files in a unique one
  test <- cbind(cbind(x_test, subject_test), y_test)
  #Merging together the datasets
  merged <- rbind(training, test)
  message("Datasets merged.")

  merged
}


filterMerged <- function(merged) {
  # Features lists the labels of the features for the x_train dataset. Since we have binded also subject and y_test(activities), add
  # them at the end of the labels list, the original one ends at 561
  labels <- rbind(rbind(features, c(562, "Subject")), c(563, "ActivityId"))[,2]
  #Assign the labels as names for the merged dataset
  names(merged) <- labels
  #Take all the rows, just the columns that contains mean, std or are related to Subject and Activities
  filteredSensor <- merged[,grepl("mean|std|Subject|ActivityId", names(merged))]
  message("Dataset filtered.")

  filteredSensor
}

refactorNames <- function(filteredSensor) {
  #Assign the activity name to each row
  filteredSensor <- merge(filteredSensor, activity_labels, by = "ActivityId")
  #We have replaced the ActivityId column with a textual description, we can remove it
  filteredSensor$ActivityId <- NULL

  # Remove useless parentheses
  names(filteredSensor) <- gsub('\\(|\\)',"",names(filteredSensor))

  #Ensure that we assign to the dataset only syntactically valid names
  #consisting of letters, numbers and the dot or underline characters and starts with a letter or the dot not followed by a number.
  names(filteredSensor) <- make.names(names(filteredSensor))

  # Turn the names in the dataset in a human readable format
  names(filteredSensor) <- gsub('^t',"TimeD.",names(filteredSensor))
  names(filteredSensor) <- gsub('^f',"FrequencyD.",names(filteredSensor))
  names(filteredSensor) <- gsub('\\.mean',".Mean",names(filteredSensor))
  names(filteredSensor) <- gsub('\\.std',".Std",names(filteredSensor))
  names(filteredSensor) <- gsub('Acc',"Acceleration",names(filteredSensor))
  names(filteredSensor) <- gsub('Mag',"Magnitude",names(filteredSensor))
  names(filteredSensor) <- gsub('Freq\\.',"Frequency.",names(filteredSensor))
  names(filteredSensor) <- gsub('Freq$',"Frequency",names(filteredSensor))
  names(filteredSensor) <- gsub('BodyBody',"Body",names(filteredSensor))

  message("Dataset features labels refactored.")

  filteredSensor
}

writeTidy <- function(filteredSensor) {
  # We have to return the filtered data with the average of each variable for each activity and each subject.
  # Ddply with numcolwise(mean) applies the mean column by column for each numerical column
  # over the data grouped by Subject and Activity and then combines the result into a data frame.

  tidyDataset <- ddply(filteredSensor, c("Subject","Activity"), numcolwise(mean))

  #As required, the output file should not have the row names
  write.table(tidyDataset, file = "tidyDataset.txt", row.names = FALSE)
  message("Wrote the tidied dataset to disk as tidyDataset.txt")
}
