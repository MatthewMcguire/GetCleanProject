# Getting and Cleaning Data course project

This project combines data files, selects a subset of variables, and summaries the data in a small summary file exported to the working directory.

#### **Execution**
The script to be executed is named *run_analysis.R*. It is self-contained, with no supporting scripts. 

#### **Dependencies**
This script assumes that the dplyr library is available to load. It also expects the following data files to be available in the working directory:
* X_test.txt
* X_train.txt
* y_test.txt
* y_train.txt
* features.txt
* subject_test.txt
* subject_train.txt
* activity_labels.txt

#### **Logic**
The script is divided into five parts, following the logic described in the project instructions.

**Part One:**
The first part simply loads the train and test data frames and merges them into a third, complete data frame named *x*. They are merged with a simple *rbind*, and then the (very large) component data frames are removed from memory!

**Part Two:**
In the second part, the data is culled and labelled. The subject and activity data columnns (from the subject and y files, respectively) are read and added to the main *x* data frame. The script also removes all columns that do not refer to a *mean* or a *standard deviation*. First, a logical vector is created that is TRUE only for columns with 'mean' or 'std' in the name. Then, the data frame is reduced to only the columns marked TRUE in this vector.

``` R
isStandDev_or_Mean <- grepl( "mean|std", featureNames, ignore.case = TRUE)
x <- x[,featureNames[isStandDev_or_Mean]]
```

**Part Three:**
The activity labels are read from their file, and every numeric code in the Activity column of the main data frame is changed to the actual word, e.g. WALKING.

**Part Four:**
The *features.txt* file contains the names of the data columns. These are maintained as the descriptive variable names, despite their rather technical and abbreviated nature. There are 86 of them, and it would require some domain knowledge to transform them into something more understandable.

**Part Five:**
Finally, the 10299 observations of the main data frame are summarized by taking the mean of each column, and placing these means into a new, summary data frame. This is done many times, by breaking down the observations by Activity name and by Subject number. The project does not specify exactly how far this grouping must be extended, so I have done it in two ways: on one hand, each Subject is grouped by Activity and each Activity is also grouped by Subject. And on the other, the observations are also grouped by Activity and *all* Subjects, as well as by Subject and *all* Activities. The identiy of the various combinations is made clear in the first two columns: **Subject** and **Activity**. The result is then written to a space-delimited text file named "smallSummary.txt".