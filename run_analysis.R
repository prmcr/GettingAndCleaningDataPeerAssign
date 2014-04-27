# setwd("~/Courses/DataScience/GettingAndCleaningData/week3Peer/")
# install.packages("stringr")

library("stringr")
library(plyr)

filepathexists <- function(filepath){
  if(!file.exists(filepath)){
    stop(cat("ERROR: ",dir," doesn't exist\n"))
  }
  invisible(file.exists(filepath))
}

dir <- "UCI HAR Dataset"
dirsep <-"/"

train.dir <- paste(dir,dirsep,"train", sep="")
test.dir <- paste(dir,dirsep,"test", sep="")

train.subjectfile <- paste(train.dir,dirsep,"subject_train.txt", sep="")
test.subjectfile <- paste(test.dir,dirsep,"subject_test.txt", sep="")

train.Xfile <- paste(train.dir,dirsep,"X_train.txt", sep="")
test.Xfile <- paste(test.dir,dirsep,"X_test.txt", sep="")
train.yfile <- paste(train.dir,dirsep,"y_train.txt", sep="")
test.yfile <- paste(test.dir,dirsep,"y_test.txt", sep="")

feature.descfile <-  paste(dir,dirsep,"features.txt", sep="")
activity.descfile <-  paste(dir,dirsep,"activity_labels.txt", sep="")

## stop if "UCI HAR Dataset" does not have the required files 
filepathexists(dir)
filepathexists(train.dir)
filepathexists(test.dir)
filepathexists(train.subjectfile)
filepathexists(test.subjectfile)
filepathexists(train.Xfile)
filepathexists(test.Xfile)
filepathexists(train.yfile)
filepathexists(test.yfile)
filepathexists(feature.descfile)
filepathexists(activity.descfile)


## 1. Merges the training and the test sets to create one data set.

## load train and test datasets

train.X <- read.table(file=train.Xfile,header=FALSE,na.strings="NA")
test.X <- read.table(file=test.Xfile,header=FALSE,na.strings="NA")

train.y <- read.table(file=train.yfile,header=FALSE,na.strings="NA")
test.y <- read.table(file=test.yfile,header=FALSE,na.strings="NA")
names(test.y) <- c("ActivityID")
names(train.y) <- c("ActivityID")

test.subject <- read.table(file=test.subjectfile,header=FALSE,na.strings="NA")
train.subject <- read.table(file=train.subjectfile,header=FALSE,na.strings="NA")
names(test.subject) <- c("SubjectID")
names(train.subject) <- c("SubjectID")

# sapply(list(train.X,train.y,test.X,test.y,test.subject,train.subject),dim)

feature.desc <- read.table(file=feature.descfile,header=FALSE)
names(test.X) <- feature.desc[,2]
names(train.X) <- feature.desc[,2]

activity.desc <- read.table(file=activity.descfile,header=FALSE)
names(activity.desc) <- c("ActivityID","ActivityDescription")

# join(test.y,activity.desc,by="ActivityID")[,2]

# test.datac <- cbind(test.subject,join(test.y,activity.desc,by="ActivityID")[,2],test.X)
test.data <- cbind(test.subject,join(test.y,activity.desc,by="ActivityID")[,2],test.y,test.X)
train.data <- cbind(train.subject,join(train.y,activity.desc,by="ActivityID")[,2],train.y,train.X)
names(test.data)[2] <- "ActivityDescription"
names(train.data)[2] <- "ActivityDescription"

merged.data <- rbind(train.data,test.data)

# names(merged.data)
# dim(merged.data)

write.table(merged.data, file = "merged.train.test.data.txt")

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# test.truncated.data <- test.data[,!is.na(c(1,1,1,str_match(names(test.X),"mean\\(\\)|std\\(\\)|Mean$")))]

test.truncated.data <- test.data[,!is.na(c(1,1,1,str_match(names(test.X),"mean\\(\\)|std\\(\\)")))]
test.truncated.X <- test.data[,!is.na(c(NA,NA,NA,str_match(names(test.X),"mean\\(\\)|std\\(\\)")))]
test.trauncated.y <- test.truncated.data$ActivityID

train.truncated.data <- train.data[,!is.na(c(1,1,1,str_match(names(train.X),"mean\\(\\)|std\\(\\)")))]
train.truncated.X <- train.data[,!is.na(c(NA,NA,NA,str_match(names(train.X),"mean\\(\\)|std\\(\\)")))]
train.trauncated.y <- train.truncated.data$ActivityID

merged.truncated.data <- rbind(train.truncated.data,test.truncated.data)
merged.truncated.X <- rbind(train.truncated.X,test.truncated.X)
merged.trauncated.y <- merged.truncated.data$ActivityID

# sapply(list(train.truncated.data,train.truncated.X,test.truncated.data,test.truncated.X),dim)

## 3. Uses descriptive activity names to name the activities in the data set

##Done before merging itself.
merged.data$ActivityDescription

## 4. Appropriately labels the data set with descriptive activity names. 

## Done 
names(merged.data)

## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

new.data <- sapply(split(merged.data,list(merged.data$SubjectID,merged.data$ActivityDescription)),function(d) colMeans(d[,4:(dim(d)[2])]))
str(new.data)

# tmp.data <- split(test.datac[,3],list(sort(test.datac$SubjectID),test.datac$ActivityDescription))
# str(tmp.data)
