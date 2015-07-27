# Getting and Cleaning Data course project

This project combines data files, selects a subset of variables, and summaries the data in a small summary file exported to the working directory.

#### **Execution**
The script to be executed is named *run_analysis.R*. It is self-contained, with no supporting scripts. 

#### **Dependencies**
This script assumes that the dplyr library is available to load. It also expects the following data files to be available in the working directory:
* X_test.txt
* X_train.txt
* features.txt
* subject_test.txt
* subject_train.txt
* activity_labels.txt

#### **Logic**
The script is divided into five parts, following the logic described in the project instructions.