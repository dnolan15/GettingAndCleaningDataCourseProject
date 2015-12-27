# AUTHOR: Daniel Nolan
# DATE: Dec. 27, 2015
# The purpose of the following script is to generate a tidy dataset from the datasets included
# in a zip archive made available by the UCI Human Activity Recognition (HAR) project

# set working directory

setwd("C:\\CourseProject")

# The commented lines below are not necessary to rerun once the data set has been downloaded and extracted.
#
# fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# 
# download.file(fileURL, "UCI_HAR.zip")
# 
# dateDownloaded <- date()
# 
# unzip("UCI_HAR.zip", overwrite = TRUE, exdir = getwd())

# load training data into data frame, append activity codes and subject IDs
train <- cbind(read.table("UCI HAR Dataset\\train\\X_train.txt", header=FALSE),
               read.table("UCI HAR Dataset\\train\\y_train.txt", header=FALSE),
               read.table("UCI HAR Dataset\\train\\subject_train.txt", header=FALSE)
)

# load test data into data frame, append activity codes and subject IDs
test  <- cbind(read.table("UCI HAR Dataset\\test\\X_test.txt", header=FALSE),
               read.table("UCI HAR Dataset\\test\\y_test.txt", header=FALSE),
               read.table("UCI HAR Dataset\\test\\subject_test.txt", header=FALSE)
)

# load features (i.e., column names, or attributes) into data frame
features <- read.table("UCI HAR Dataset\\features.txt", header=FALSE)

# manipulate feature names so that they are more R-friendly
features$V2 <- tolower(features$V2)      # remove mixed case, set to lower
features$V2 <- gsub("-","_",features$V2) # replace dashes with underscores
features$V2 <- gsub(",","_",features$V2) # replace commas with underscores
features$V2 <- gsub("()","",features$V2) # remove pairs of parentheses (functional dependency is omitted anyway)

# "merge" data -- i prefer to think of this as taking the UNION
HAR <- rbind(train, test)

relevantCols      <- grep(".*mean.*|.*std.*", features$V2) # extract columns involving 'mean' or 'std'
relevantFeatures  <- c(features$V2[relevantCols], "activity_id", "subject_id") # include activity code and subject ID
relevantCols      <- c(relevantCols, 562, 563)

# subset data (simple operation, hence the use of base R rather than, e.g., dplyr)
HAR_Subset <- HAR[,relevantCols]

# set column names
colnames(HAR_Subset) <- relevantFeatures

# merge with activity label data
activities <- read.table("UCI HAR Dataset\\activity_labels.txt",
                         header=FALSE,
                         col.names = c("activity_id", "activity_desc")
                         ) # load activity codes into data frame
HAR_Subset <- merge(HAR_Subset, activities, by.x = "activity_id", by.y = "activity_id")

HAR_Subset$activity_desc <- as.factor(HAR_Subset$activity_desc)

# aggregate data into tidy dataset
tidy <- suppressWarnings(
          aggregate(HAR_Subset,
                    by=list(activity=HAR_Subset$activity_desc, subject=HAR_Subset$subject_id),
                    FUN=mean,
                    na.rm = TRUE
          )
)

# remove superfluous columns
tidy <- tidy[,!(names(tidy) %in% c("activity_desc", "subject_id"))]

# write to text file
write.table(tidy, file = "tidy.txt", row.names = FALSE, sep = "\t")
