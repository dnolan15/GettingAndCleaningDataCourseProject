# GettingAndCleaningDataCourseProject
Getting and Cleaning Data - Course Project

My approach was to download the file programmatically, extract the zip archive, and clean the carry out the following steps:

1. Store the training data and the test data in separate data frames, with the activity codes (y_train/y_test) and the subject IDs adjoined to the right hand side of the data frame.
2. Store the features in their own data frame, and use the tolower() and gsub() functions to make them more readable.
3. Merge the training and test data sets. (As noted in the R file, I like to avoid the use of the word "merge" in this case -- I think of the operation as a UNION.)
4. Filter out columns not having to do with Means or Standard Deviations.
5. Aggregate the data, i.e., calculate mean across each subject-activity pair, and write the results to a file called tidy.txt.

The code book is adapted from the code book provided by the UCI research team, with all info that is not related to Means or Standard Deviations removed. Following the team's example, I've also included a list of features (relevantFeatures.txt) for completeness.
