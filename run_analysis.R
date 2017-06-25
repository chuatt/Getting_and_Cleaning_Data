#!/usr/bin/Rscript
#read all test data
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

#read all train data
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

#add Column name to Subject & Labels
colnames(subject_test) <- "SubjectID"
colnames(subject_train) <- "SubjectID"
colnames(y_test) <- "Activity"
colnames(y_train) <- "Activity"

#read features.txt
features <- read.table("./UCI HAR Dataset/features.txt")

#add Column names to x_test & x_train
names(x_test) <- features$V2
names(x_train) <- features$V2

#Join subject,x & y together
all_test <- cbind(subject_test,y_test,x_test) 
all_train <- cbind(subject_train,y_train,x_train)

#combine all_test & all_train
combine <- rbind(all_test,all_train)

#call reshape2 library
library(reshape2)

#keep col with "mean()" and "std()" 
col_with_mean_std <- grepl("mean|std//(//)", names(combine))

#keep also first 2 columns
col_with_mean_std[1:2] <- TRUE

#filter col with mean & std
filtered <- combine[,col_with_mean_std]

#Use descriptive activity names to name the activities in the data set
filtered$Activity <- replace(filtered$Activity, filtered$Activity==1, "Walking")
filtered$Activity <- replace(filtered$Activity, filtered$Activity==2, "Walking Upstairs")
filtered$Activity <- replace(filtered$Activity, filtered$Activity==3, "Walking Downstairs")
filtered$Activity <- replace(filtered$Activity, filtered$Activity==4, "Sitting")
filtered$Activity <- replace(filtered$Activity, filtered$Activity==5, "Standing")
filtered$Activity <- replace(filtered$Activity, filtered$Activity==6, "Laying")

#melt data into SubjectID & Activity
melted <- melt(filtered, id=c("SubjectID", "Activity"))

#creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidydata <- dcast(melted, SubjectID+Activity ~ variable,mean)

#create data set as a csv file created with write.csv() using row.name=FALSE
write.csv(tidydata, file="tidydata.csv", row.names=FALSE)
