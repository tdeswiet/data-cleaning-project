# Load the test and train data sets.
X_test <- read.table("UCI HAR Dataset/test/X_test.txt", quote="\"", stringsAsFactors=FALSE)
X_train <- read.table("UCI HAR Dataset/train/X_train.txt", quote="\"", stringsAsFactors=FALSE)

# Combine into a single frame.
hartidy <- rbind(X_test,X_train)

# Load the column names
features <- read.table("UCI HAR Dataset/features.txt", quote="\"", stringsAsFactors=FALSE)

# Find the columns that are mean or standard deviations
keepcols <- sort(c(grep("mean()",features[,2],fixed=T),grep("std()",features[,2],fixed=T)))

# Keep just those columns with descriptive names
hartidy <- hartidy[,keepcols]
colnames(hartidy) <- features[keepcols,2]

# Assemble the subject column
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", quote="\"")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", quote="\"")
subject <- rbind(subject_test,subject_train)
colnames(subject) <- "subject"


# Get the activities and their descriptive labels
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", quote="\"")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", quote="\"")
activity <- rbind(y_test,y_train)
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", quote="\"",stringsAsFactors=FALSE)
library(plyr)
activity <- mapvalues(activity[,1],activity_labels[,1],activity_labels[,2],warn_missing = T)

# Bind together the tidy data set, naming activity inline
hartidy <- cbind(subject, activity = activity, hartidy)

# Create second data set for export with the average of each column for a subject and activity
# Write this to a text file
hartidyav <- t(sapply(split(hartidy[,3:68],list(hartidy$subject,hartidy$activity)),colMeans))
# In order to apply ColMeans, I stripped off the subject and activity columns which were used as factors
# The row names of the new matrix are things like "1.LAYING"
write.table(hartidyav,file = "hartidyav.txt", row.names = F)


