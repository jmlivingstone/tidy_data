library(dplyr)

# download data
file <- paste0(Sys.Date(), "final_project_date.zip")
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", file, method="curl")
cmd <- paste("unzip", file)
system(cmd)

#read data into R
train <- read.delim("UCI HAR Dataset/train/X_train.txt", as.is=T, sep ="", header=F)
test <-read.delim("UCI HAR Dataset/test/X_test.txt", as.is=T, sep="", header=F)

# annotate data
features <- read.delim("UCI HAR Dataset/features.txt",as.is=T, header=F, sep ="")[,2]
colnames(test) <- features
colnames(train) <- features

# get information about subjects
strain <- read.delim("UCI HAR Dataset/train/subject_train.txt", header=F)[,1]
stest <- read.delim("UCI HAR Dataset/test/subject_test.txt", header=F)[,1]

# create column with activity labels
ytrain <- read.delim("UCI HAR Dataset/train/y_train.txt", header=F)[,1]
ytest <- read.delim("UCI HAR Dataset/test/y_test.txt", header=F)[,1]

# create column with subject information
train_c <- cbind(strain, ytrain, train)
test_c <- cbind(stest, ytest, test)
colnames(test_c)[1] <- colnames(train_c)[1] <- "subject"
colnames(test_c)[2] <- colnames(train_c)[2] <- "activity"

# combine test and training data into one (step 1)
all <- rbind(test_c, train_c)

# gather only columns that have information about mean and standard deviation metrics (step 2)
all <- all[,c(1,2,grep(paste(c("[mM]ean","std"),collapse="|"), colnames(all))]

# annotate activity labels with descriptive variable names (step 3)
all$activity <- c("walking", "walking_upstairs", "walking_downstairs", "sitting", "standing", "laying")[match(all$activity, c(1,2,3,4,5,6))]

#(step 4)
tmp <- colnames(all)
tmp <- gsub("^t", "time_", tmp, perl = T)
#tmp <- gsub("Body", "_of_the_body", tmp, perl = T)
tmp <- gsub("^f", "signal_frequency_", tmp, perl = T)
tmp <- gsub("Freq", "frequency", tmp, perl=T)
tmp <- gsub("-mean\\(\\)", "-mean", tmp, perl = T)
tmp <- gsub("-std\\(\\)", "-standard_deviation", tmp, perl = T)
tmp <- gsub("-Z", "on_the_Z_axis", tmp, perl = T)
tmp <- gsub("-X", "on_the_X_axis", tmp, perl = T)
tmp <- gsub("-Y", "on_the_Y_axis", tmp, perl = T)
tmp <- gsub("Acc", "_acceleration", tmp, perl=T)
tmp <- gsub("Mag", "_magnitude", tmp, perl=T)
tmp <- gsub("Gyro", "_gyroscope_measurement_", tmp, perl=T)
colnames(all) <- tmp

#average of each variable for each activity (step 5)
step5 <- group_by(all, subject,activity) %>% summarise_each(funs(mean))

write.table(step5, file = "jlivingstone_tidy_data_final_assign.txt", row.names=F, colnames=F, quote=F, sep="\t")
