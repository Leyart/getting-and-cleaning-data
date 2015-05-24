Getting and Cleaning Data Course Project
========================================

Course project deliverables for the Coursera course [Getting and Cleaning Data](https://www.coursera.org/course/getdata)

## Installation
* Clone this repository: `git clone git@github.com:Lucg/Lucg/getting-and-cleaning-data.git` in a directory that we will call `directory`
* Download the raw data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip to `directory` and unzip it. You can delete the zip file after this step.
  Your directory structure should look like this now (only shown 2 levels deep):

 ```
    ├── UCI HAR Dataset
    │   ├── README.txt
    │   ├── activity_labels.txt
    │   ├── features.txt
    │   ├── features_info.txt
    │   ├── test
    │   └── train
    ├── run_analysis.R
    ├── README.md
    └── CodeBook.md
 ```

## Dependencies
The script `run_analysis.R` depends on the libraries `plyr` and `utils`. If you have not installed them, the script will prompt to install them automatically.

## Running the analysis
* Change the working directory with setwd in R to the installation directory (called `directory` in the [Installation](#Installation) section).
* Source the script `run_analysis.R` in R: `source("run_analysis.R")`
* Execute the function `tidyDataset` with no arguments if the dataset is already in place `tidyDataset()` or by passing TRUE if you want to download the dataset automatically `tidyDataset(TRUE)`
* The system will check package dependencies automatically and will ask to download them if they are not present. If the user denies this possibility, the system will quit
gracefully
* The resulting tidied dataset will be generated in the root of the directory under the name "tidyDataset.txt"

## Codebook
Information about the datasets is provided in `CodeBook.md`.

## Code
The code contains detailed commments explaining the steps with which the original data was transformed to the tidied dataset
