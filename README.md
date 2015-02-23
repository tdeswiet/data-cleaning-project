---
title: "README"
author: "Tom de Swiet"
date: "Sunday, February 22, 2015"
output: html_document
---

This is description of the run_analysis file to create a tidy data set. 


First load the test and train data sets:
```{r}
X_test <- read.table("UCI HAR Dataset/test/X_test.txt", quote="\"", stringsAsFactors=FALSE)
X_train <- read.table("UCI HAR Dataset/train/X_train.txt", quote="\"", stringsAsFactors=FALSE)
```

Then combine into a single frame.
```{r}
hartidy <- rbind(X_test,X_train)
```

 Load the column names and find the columns that are mean or standard deviations
```{r}
features <- read.table("UCI HAR Dataset/features.txt", quote="\"", stringsAsFactors=FALSE)
keepcols <- sort(c(grep("mean()",features[,2],fixed=T),grep("std()",features[,2],fixed=T)))
```

Keep just those mean/std columns and add descriptive names
```{r}
hartidy <- hartidy[,keepcols]
colnames(hartidy) <- features[keepcols,2]
```

Assemble the subject column
```{r}
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", quote="\"")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", quote="\"")
subject <- rbind(subject_test,subject_train)
colnames(subject) <- "subject"
```

Get the activities and their descriptive labels. Use the plyr package to map the activity descriptions to the the numbers.
```{r}
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", quote="\"")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", quote="\"")
activity <- rbind(y_test,y_train)
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", quote="\"",stringsAsFactors=FALSE)
library(plyr)
activity <- mapvalues(activity[,1],activity_labels[,1],activity_labels[,2],warn_missing = T)
```

Bind together the tidy data set "hartidy", naming the activities inline
```{r}
hartidy <- cbind(subject, activity = activity, hartidy)
```

Create a second data set "hartidyav" for export with the average of each column for a subject and activity
Write this to a text file. Here split is used to partition hartidy by both subject and activity simultaneously. The first two columns - subject and activity - are not included, so that we can find the means with the ColMeans function and sapply. Note that the subject and activity are still present in the form of row names for the final output, which have format "subject number.activity" e.g. 1.LAYING.
```{r}
hartidyav <- t(sapply(split(hartidy[,3:68],list(hartidy$subject,hartidy$activity)),colMeans))
write.table(hartidyav,file = "hartidyav.txt", row.names = F)
```


