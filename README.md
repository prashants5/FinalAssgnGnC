# Introduction
This Readme outlines the methodology for obtaining the output file as described in the Coursera Getting and Cleaning Data Major Assignment page at:

https://www.coursera.org/learn/data-cleaning/peer/FIZtT/getting-and-cleaning-data-course-project

# The following files are included:

- 'README.md’
- ‘CodeBook.md’: Data dictionary / codebook for output data
- ‘run_analysis.R’: R Script file for analysing and generating output file

# Execution and Analysis
To run the data in R:
`source(“run_analysis.R”)`

To view the output:
`AssignmentData = read.csv(“./VariableMeans_by_ActivitySubject.csv”, header=TRUE)`

# Methodology
The source data is described at:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## 1: Data download and merge
The `run_analysis.R` file first downloads the source zip file and unpacks it.  

The data is loaded into R data tables, and column headings added where appropriate.

The test and training data are combined and merged into one CompleteData variable.

## 2: STDEV and MEAN subsetting
Of the 561 features, 86 features are selected as they represent mean and standard deviation measurements.  Variable names were searched for:
* Presence of string “mean” or “Mean”
* Presence of string “std”

The variable Mean_Std_Subset is the completed subset data with columns for activity and subject id.

## 3: Renaming Activities with descriptive names
This was achieved by using the index in the Mean_Std_Subset table to lookup the activity labels and replace with the descriptive text.

## 4: Descriptive Variable Names
The following abbreviations were replaced in the original activity names:
* t -> time
* f -> frequency
* Acc -> Accelerometer
* Gyro -> Gyroscope
* Mag -> Magnitude

## 5: Final Tidy Data Set
The final data set represents summary statistics for the MEAN and STDEV variables.  The MEAN of these variables is calculated and sorted by activity label and subject id.  The resulting table has 180 rows (30 subjects x 6 activities).

The `reshape` library was chosen as it does not require re-arranging the data as is the case with `plyr`.
 

## Other Notes
* The cat function is used to give user feedback throughout script execution, especially during the initial stages where data processing takes time.
* Ignored the inertia folder - not needed.