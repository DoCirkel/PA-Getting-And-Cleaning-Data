# R script for the Assignment of Getting and Cleaning Data Course Project
# 22-12-2017
# D.R. Cirkel


# Necessary libraries
library(readr)
library(dplyr)
library(tidyr)


# Read in the data. Assign colnames to the datasets with only one variable. 
X_test <- read_table("~/Courses/Coursera/Opdrachten/GettingandCleaningData/UCI HAR Dataset/test/X_test.txt", col_names = FALSE)
X_train <- read_table("~/Courses/Coursera/Opdrachten/GettingandCleaningData/UCI HAR Dataset/train/X_train.txt", col_names = FALSE)
y_test <- read_csv("~/Courses/Coursera/Opdrachten/GettingandCleaningData/UCI HAR Dataset/test/y_test.txt", col_names = "Number_outcome")
y_train <- read_csv("~/Courses/Coursera/Opdrachten/GettingandCleaningData/UCI HAR Dataset/train/y_train.txt", col_names = "Number_outcome")
subject_test <- read_csv("~/Courses/Coursera/Opdrachten/GettingandCleaningData/UCI HAR Dataset/test/subject_test.txt",col_names = "Subject")
subject_train <- read_csv("~/Courses/Coursera/Opdrachten/GettingandCleaningData/UCI HAR Dataset/train/subject_train.txt", col_names = "Subject")
features <- read_table("~/Courses/Coursera/Opdrachten/GettingandCleaningData/UCI HAR Dataset/features.txt", col_names = "Features")
activity_labels <- read_csv("~/Courses/Coursera/Opdrachten/GettingandCleaningData/UCI HAR Dataset/activity_labels.txt", col_names = "Number_activity")


# Merge the train and test sets together
X_Data <- as.data.frame(rbind(X_test, X_train))
y_Data <- as.data.frame(rbind(y_test, y_train))
subject_Data <- as.data.frame(rbind(subject_test, subject_train))

# Also assign the remaining colnames from 'features'
colnames(X_Data) = features$Features

# Seperate the number from the activity label 
activity_labels <- activity_labels %>%
  separate(Number_activity, c("number", "Activity"), " ")


# Combine data sets
Data <- select(X_Data, contains("mean()"), contains("std()")) %>%         # Select the columns from X_Data that contain mean or std in the name
  cbind(y_Data, subject_Data) %>%                                     # Merge outcome with y and subject data
  merge(activity_labels, by.x = "Number_outcome", by.y = "number")%>% # Assign activity labels to the outcome By numberoutcome and by number
  select(-c(Number_outcome))                                          # Delete unnessecary column



# Create second Dataset
Data2 <- Data %>%                                       
  group_by(Activity, Subject) %>%                                     # Group by activity and subject
  summarize_all(funs(mean))                                           # get average of every variable


write.table(Data, file = "Data")
write.table(Data2, file = "Data2")
