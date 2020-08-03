library(dplyr)
x_train = read.table("~/UCI HAR Dataset/train/X_train.txt")
y_train = read.table("~/UCI HAR Dataset/train/y_train.txt")
subject_train = read.table("~/UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("~/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("~/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("~/UCI HAR Dataset/test/subject_test.txt")

features <- read.table("~/UCI HAR Dataset/features.txt")

activity_labels <- read.table("~/UCI HAR Dataset/activity_labels.txt")

x_full = rbind(x_train, x_test)
y_full = rbind(y_train, y_test) 
subject_full = rbind(subject_train, subject_test) 

sel_features = features[grep(".*mean\\(\\)|std\\(\\)", features[,2], ignore.case = FALSE),]
x_full = x_full[,sel_features[,1]]

colnames(x_full)   <- sel_features[,2]
colnames(y_full)   <- "activity"
colnames(subject_full) <- "subject"

merged <- cbind(subject_full, y_full, x_full)

merged$activity <- factor(merged$activity, levels = activity_labels[,1], labels = activity_labels[,2]) 
merged$subject  <- as.factor(merged$subject) 

final <- merged %>% group_by(activity, subject) %>% summarize_all(funs(mean)) 
