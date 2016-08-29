# Step 1: Download Zip File, Extract Data, Load into R data frames
cat("Step 1: Downloading Data Files and Loading into R")
baseDir = "./data"
baseDataDir = "./data/UCI HAR Dataset/"

if(!file.exists(baseDir)){dir.create(baseDir)}

mainFileURL= "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destFile = "./data/AssignmentDataSet.zip"

download.file(mainFileURL, destFile, method="curl")

cat("Main Zip File Downloaded\n")

unzip(destFile, exdir = baseDir)

cat("Files Extracted from Zip File\n")

# Read the files into R - in their original form - into 
# R data frames with apppropriate column names where applicable.


features_orig = read.table(paste(baseDataDir,"features.txt", sep=""), header = FALSE, col.names = c("feature_index", "feature_name") ,stringsAsFactors = FALSE)
activitylabels_orig = read.table(paste(baseDataDir,"activity_labels.txt", sep=""), header = FALSE, col.names = c("activity_index", "activity_name") ,stringsAsFactors = FALSE)
cat("Reading Training Data - please wait\n")
xTrain_orig = read.table(paste(baseDataDir,"train/X_train.txt", sep=""), header = FALSE, stringsAsFactors = FALSE)
yTrain_orig = read.table(paste(baseDataDir,"train/y_train.txt", sep=""), header = FALSE, col.names = c("activity_index"), stringsAsFactors = FALSE)
subjectTrain_orig = read.table(paste(baseDataDir,"train/subject_train.txt", sep=""), header = FALSE, col.names = c("subject_id"), stringsAsFactors = FALSE)
cat("Training Data Loaded\n")
cat("Reading Test Data - please wait\n")

xTest_orig = read.table(paste(baseDataDir,"test/X_test.txt", sep=""), header = FALSE, stringsAsFactors = FALSE)
yTest_orig = read.table(paste(baseDataDir,"test/y_test.txt", sep=""), header = FALSE, col.names = c("activity_index"), stringsAsFactors = FALSE)
subjectTest_orig = read.table(paste(baseDataDir,"test/subject_test.txt", sep=""), header = FALSE, col.names = c("subject_id"), stringsAsFactors = FALSE)

cat("Test Data Loaded\n")
cat("Merging Data Sets\n")

# Add feature labels into Training and Test Data
colnames(xTrain_orig) = features_orig[,2]
colnames(xTest_orig) = features_orig[,2]

TrainingMerge = cbind(yTrain_orig, subjectTrain_orig, xTrain_orig)
TestMerge = cbind(yTest_orig, subjectTest_orig, xTest_orig)
CompleteData = rbind(TrainingMerge, TestMerge)

#2 Extract only the data containing mean and stdev columns, and give them descriptive names.

# Create char vector of mean and std column names

CompleteDataColNames = names(CompleteData)
Mean_Std_Cols_Filter = grep("(std|[Mm]ean)", CompleteDataColNames, value = TRUE)
# Combine with activity_index and subject_id as first two columns to complete col names

Mean_Std_Cols = c(CompleteDataColNames[1], CompleteDataColNames[2], Mean_Std_Cols_Filter)

# Apply filtered col names to get subset of data.
Mean_Std_SubSet = CompleteData[Mean_Std_Cols]

#3. Replace activity_index column in Subset with string representing actual Activity Label

# Create temp array of indices of activity - used to index lookup table
activity_indices_subset = Mean_Std_SubSet$activity_index

# Replace Index in table by looking up index from original column.  "2" is fixed as the 2nd column containing
# the labels
for(i in seq_along(Mean_Std_SubSet$activity_index))
  Mean_Std_SubSet$activity_index[i] = activitylabels_orig[ activity_indices_subset[i] , 2]


#4 & 5. Combined Below

#5. Create final tidy data set of means of variables for each activity for each subject
# Melt data for later aggregation.  Output will be columns called variable and value with original variables melted.
Mean_Std_SubSet_Melt = melt(Mean_Std_SubSet, id=c("subject_id", "activity_index"), measure.vars= Mean_Std_Cols_Filter)


# Cast molten data to get final table.  Note mean function is used as final argument.
VarMeansBySubjectActivity = dcast(Mean_Std_SubSet_Melt, subject_id + activity_index ~ variable, mean)

#4. Makes column variable names more readable.
names(VarMeansBySubjectActivity) = gsub("^t", "time", names(VarMeansBySubjectActivity))
names(VarMeansBySubjectActivity) = gsub("^f", "frequency", names(VarMeansBySubjectActivity))
names(VarMeansBySubjectActivity) = gsub("Acc", "Accelerometer", names(VarMeansBySubjectActivity))
names(VarMeansBySubjectActivity) = gsub("Gyro", "Gyroscope", names(VarMeansBySubjectActivity))
names(VarMeansBySubjectActivity) = gsub("Mag", "Magnitude", names(VarMeansBySubjectActivity))
names(VarMeansBySubjectActivity) = gsub("BodyBody", "Body", names(VarMeansBySubjectActivity))
names(VarMeansBySubjectActivity) = gsub("mean", "MEAN", names(VarMeansBySubjectActivity))
names(VarMeansBySubjectActivity) = gsub("std", "STDEV", names(VarMeansBySubjectActivity))

# Write table to file.
write.table(VarMeansBySubjectActivity, "./VariableMeans_by_ActivitySubject.txt", row.names = FALSE)

cat("Operation Complete\n")