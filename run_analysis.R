library(dplyr)

# PART ONE:
# Merge the training and the test sets to create one data set.

# load train and test x values into dataframes
x_test <- read.table("X_test.txt")
x_train <- read.table("X_train.txt")

# combine them into a single dataframe
x <- rbind(x_test, x_train)
rm(x_test)
rm(x_train)

# PART TWO:
# Extracts only the measurements on the mean and 
# standard deviation for each measurement.

# load features.txt
features <- read.table("features.txt")
featureNames <- as.vector(features[,2], mode="character")
colnames(x) <- featureNames

# identify which features are mean and std. dv.
isStandDev_or_Mean <- grepl( "mean|std", featureNames, ignore.case = TRUE)

# remove the data frame columns not referring to mean or std
x <- x[,featureNames[isStandDev_or_Mean]]

# load train and test Y data 
y_test <- read.table("y_test.txt")
y_train <- read.table("y_train.txt")

# combine train and test Y data
y <- rbind(y_test, y_train)
rm(y_test)
rm(y_train)

# load train and test Subject data 
subject_test <- read.table("subject_test.txt")
subject_train <- read.table("subject_train.txt")

# combine train and test Subject data
subject <- rbind(subject_test, subject_train)
rm(subject_test)
rm(subject_train)

# add df columns for Activity and Subject
x$ActivityCode <- as.vector(y[,1])
x$Subject <- as.vector(subject[,1])

# PART THREE:
# Uses descriptive activity names to name the activities in the data set
activityLabels <- read.table("activity_labels.txt", as.is=T)

# change activity codes to words
colnames(activityLabels) <- c("ActivityCode", "Activity")
x <- merge(x, activityLabels, by.x="ActivityCode", by.y="ActivityCode")
x  <- select(x, -ActivityCode)

# PART FOUR:
# Appropriately label the data set with descriptive variable names. 
# (already completed above)

rm(subject)
rm(y)

# PART FIVE: 
# creates a second, independent tidy data set with 
# the average of each variable for each activity and each subject.

byActivity <- group_by(x, Activity)
bySubject <- group_by(x, Subject)

# create small summary df
smallSummary <- x[1,]

# fill it with mean of each column, grouped by activity and subject
ncolsNumeric <- ncol(x)-2
iter <- 1

# calculate the mean for each activity, aggregating all subjects
for (i in unique(x$Activity))
{
  f <- filter(x, x$Activity==i)
  smallSummary[iter,] <- c(colMeans(select(f, 1:ncolsNumeric)), "ALL SUBJECTS", i)
  iter <- iter +1
}
# calculate the mean for each subject, aggregating all activities
for (i in unique(x$Subject))
{
  f <- filter(x, x$Subject==i)
  smallSummary[iter,] <- c(colMeans(select(f, 1:ncolsNumeric)), i, "ALL ACTIVITIES")
  iter <- iter +1
}
# calculate the mean for each activity and subject combination
for (i in unique(x$Activity))
{
  for (j in unique(x$Subject))
  {
    f <- filter(x, x$Subject==j & x$Activity==i)
    smallSummary[iter,] <- c(colMeans(select(f, 1:ncolsNumeric)), j, i)
    iter <- iter +1
  }
}

# re-order the table and put label columns first for clarity
smallSummary <- arrange(smallSummary,Activity,as.numeric(Subject))
last2Cols <- select(smallSummary, (ncolsNumeric+1):(ncolsNumeric+2) )
dataCols <- select(smallSummary, 1:ncolsNumeric)
smallSummary <- cbind(last2Cols, dataCols)

# write the summary data to a file
write.table(smallSummary, "smallSummary.txt", row.name=FALSE)