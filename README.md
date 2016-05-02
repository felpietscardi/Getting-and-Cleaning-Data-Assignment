# Getting and Cleaning Data Assignment

This file describes the processes of getting and cleaning the raw data and transforming it into a tidy data. The files of importance are:

* **run_analysis.R**, this script processes the data.
* **CodeBook.md**, this file contains the information and description about the data.
* **README.md**, this file explains the processes and how it can be recreated.

The **run_analusis.R** does the following:

1. Getting the file from [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip), saving it as data.zip inside the data directory then unzipping the file.
2. Reading the activities and feature labels from **activity_labels.txt** and **features.txt** respectively.
3. Reading the **train** dataset: **X_train.txt**, **y_train.txt** and **subject_train.txt**, combining them into one dataset and apply the appropriate headers.
4. Reading the **test** dataset: **X_test.txt**, **y_test.txt** and **subject_test.txt**, combining them into one dataset and apply the appropriate headers.
5. Merge the train and test dataset together, then remove the duplicate columns.
6. Find all the columns with mean() and std().
7. Replace the activities variables with a descriptive label and make the columns more descriptive
8. Create a tidy data by grouping the dataset by subjects and activities, then summarising each of the columns.
9. Create a file from the tidy data called **tidy_data.txt** in the working directory.