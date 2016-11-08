# load plyr 
library(plyr)

# set working directory
setwd("C:/coursera/assinment_getting_cleaning_data")

fname <- "getdata_dataset.zip"
fdir <- "UCI HAR Dataset"

#download and unzip file if necessary
if (!file.exists(fdir)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, fname)
  unzip(fname)
} 

#Move on to downloaded data
setwd(fdir)

##Merges the training and the test sets to create one data set.
#create dataset with training and test data
x_training <- read.table("train/X_train.txt")
y_training <- read.table("train/y_train.txt")
sub_training <- read.table("train/subject_train.txt")

x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
sub_test <- read.table("test/subject_test.txt")

x_data <- rbind(x_training, x_test)

y_data <- rbind(y_training, y_test)

subject_data <- rbind(sub_training, sub_test)

##Extracts only the measurements on the mean and standard deviation for each measurement. 
feat <- read.table("features.txt")

# find ans subset columns with only mean and std in name, set coloumn name
feat_col <- grep("-(mean|std)\\(\\)", feat[, 2])
x_data <- x_data[, feat_col]
names(x_data) <- feat[feat_col, 2]

##Uses descriptive activity names to name the activities in the data set

#Read activity-table and set right activity
act <- read.table("activity_labels.txt")
y_data[, 1] <- act[y_data[, 1], 2]
names(y_data) <- "activity"

##Appropriately labels the data set with descriptive variable names.
names(subject_data) <- "subject"

# get it all together
result <- cbind(x_data, y_data, subject_data)

##From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
avr_data <- ddply(result, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(avr_data, "avr_data.txt", row.name=FALSE)