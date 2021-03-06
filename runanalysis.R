@@ -0,0 +1,59 @@
 +## before starting load the reshape2 package for STEP 5
 +
 +library(reshape2)
 +
 +## STEP 1: Merging the train & test data into one
 +
 +# read data from files into data frames
 +subject_train <- read.table("subject_train.txt")
 +subject_test <- read.table("subject_test.txt")
 +X_train <- read.table("X_train.txt")
 +X_test <- read.table("X_test.txt")
 +Y_train <- read.table("y_train.txt")
 +Y_test <- read.table("y_test.txt")
 +
 +# add column name for subject files
 +names(subject_train) <- "subjectID"
 +names(subject_test) <- "subjectID"
 +
 +# add column names for measurement files
 +featureNames <- read.table("features.txt")
 +names(X_train) <- featureNames$V2
 +names(X_test) <- featureNames$V2
 +
 +# add column name for label files
 +names(Y_train) <- "activity"
 +names(Y_test) <- "activity"
 +
 +# combine required files into a single dataset
 +train <- cbind(subject_train, Y_train, X_train)
 +test <- cbind(subject_test, Y_test, X_test)
 +merged <- rbind(train, test)
 +
 +
 +## STEP 2: Extracts only the measurements on the mean and standard deviation for each measurement.
 +# determine which columns contain "mean()" or "std()"
 +meanstdcols <- grepl("mean\\(\\)", names(merged)) |
 +  grepl("std\\(\\)", names(merged))
 +
 +# ensure that we also keep the subjectID and activity columns
 +meanstdcols[1:2] <- TRUE
 +
 +# remove unnecessary columns
 +merged <- merged[, meanstdcols]
 +
 +
 +## STEP 3: Uses descriptive activity names to name the activities in the data set.
 +## STEP 4: Appropriately labels the data set with descriptive activity names. 
 +# convert the activity column from integer to factor
 +merged$activity <- factor(merged$activity, labels=c("Walking","Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))
 +
 +
 +## STEP 5: Creates a second, independent tidy data set with the mean of each variable for each activity and each subject.
 +
 +# create the tidy data set
 +melted <- melt(merged, id=c("subjectID","activity"))
 +tidy <- dcast(melted, subjectID+activity ~ variable, mean)
 +
 +# write the tidy data set to a file
 +write.table(tidy, "tidydata.txt", row.names=FALSE) 
 \No newline at end of file
