# Getting the files from the web
fileUrl         <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dowloadedFile   <- "./data/data.zip"
dataPath        <- "./data/UCI HAR Dataset/"

if (!file.exists(dowloadedFile)) {
    download.file(url = fileUrl, destfile = dowloadedFile)
}

if (!dir.exists(dataPath)) {
    # unzip the file
    unzip(dowloadedFile, exdir = "./data")
}

# read in the lables
activity_labels <- read.table(file = paste(dataPath, "activity_labels.txt", sep = ""), header = FALSE)
feature_labels  <- read.table(file = paste(dataPath, "features.txt", sep = ""), header = FALSE)

# train set
X_train         <- read.table(file = paste(dataPath, "train/X_train.txt", sep = ""), header = FALSE)
y_train         <- read.table(file = paste(dataPath, "train/y_train.txt", sep = ""), header = FALSE)
subject_train   <- read.table(file = paste(dataPath, "train/subject_train.txt", sep = ""), header = FALSE)
names(X_train)  <- feature_labels[, 2]

# setting appropriate header names
names(y_train)  <- "activities"
names(subject_train) <- "subjects"
merged_train    <- cbind(subject_train, y_train, X_train)

# test set
X_test          <- read.table(file = paste(dataPath, "test/X_test.txt", sep = ""), header = FALSE)
y_test          <- read.table(file = paste(dataPath, "test/y_test.txt", sep = ""), header = FALSE)
subject_test    <- read.table(file = paste(dataPath, "test/subject_test.txt", sep = ""), header = FALSE)

# setting appropriate header names
names(X_test)   <- feature_labels[, 2]
names(y_test)   <- "activities"
names(subject_test) <- "subjects"
merged_test     <- cbind(subject_test, y_test, X_test)

# putting the two datasets together
merged_data      <- rbind(merged_train, merged_test)

# removed duplicate column names
merged_data      <- merged_data[, !duplicated(colnames(merged_data))]

# find all the mean() and std() columns
library(dplyr)
extracted_data  <- select(merged_data, contains("mean()"), contains("std()"))

# put the first two columns back in (activities and subjects)
extracted_data  <- cbind(merged_data[, 1:2], extracted_data)
    
# using the activities labels
extracted_data[, 2] <- activity_labels[extracted_data[, 2], 2]

# make the column name more descriptive
names(extracted_data) <- gsub("^t", "time", names(extracted_data))
names(extracted_data) <- gsub("^f", "frequency", names(extracted_data))
names(extracted_data) <- gsub("BodyBody", "Body",names(extracted_data))
names(extracted_data) <- gsub("Mag", "Magnitude",names(extracted_data))
names(extracted_data) <- gsub(".mean", "-mean",names(extracted_data))
names(extracted_data) <- gsub(".std", "-std",names(extracted_data))
names(extracted_data) <- gsub("mean..", "mean()",names(extracted_data))
names(extracted_data) <- gsub("std..", "std()",names(extracted_data))
names(extracted_data) <- gsub("Acc", "Acceleration",names(extracted_data))
names(extracted_data) <- gsub("mean", "Mean",names(extracted_data))
names(extracted_data) <- gsub("std", "StandardDeviation",names(extracted_data))

# creating a tidy data by grouping the data set by subjects and activities, then summarising each of the columns
tidy_data <-  group_by(extracted_data, subjects, activities) %>% summarise_each(funs(mean))

# write the file to the file system
write.table(tidy_data, file = "tidy_data.txt", row.names = FALSE)
