# This script creates a tidy dataset out of data collected from the 
# accelerometers from the Samsung Galaxy S smartphone.

# Read in raw data

test <- read.table("test/X_test.txt")
ytest <- read.table("test/y_test.txt")
testsub <- read.table("test/subject_test.txt")
train <- read.table("train/X_train.txt")
ytrain <- read.table("train/y_train.txt")
trainsub <- read.table("train/subject_train.txt")

# Put the test results and training results into single-table datasets
testfull <- cbind(testsub,ytest,test)
trainfull <- cbind(trainsub,ytrain,train)

# Append the train results to the bottom of the test results
full <- rbind(testfull,trainfull)

# Read in the variable names from txt
features <- read.table("features.txt")

# Note which rows are related to mean and standard deviation
meancols <- features[grep("mean\\(\\)",features[,2]),1]
stdcols <- features[grep("std\\(\\)",features[,2]),1]
colstokeep <- append(meancols,stdcols)
colstokeep <- colstokeep[order(as.numeric(colstokeep))]

# Only keep the columns with mean and standard deviation data
fullrelevant <- full[,colstokeep+2]

# Give readable column names by using the feature identifier.
colnames(fullrelevant) <- features[colstokeep,2]

# Add back in summary data
fullrelevant2 <- cbind(full[,1:2],fullrelevant)

# Group the data by unique subjects and activities
dt <- data.frame(subject <- unique(fullrelevant2[,1])[order(unique(fullrelevant2[,1]))], activity <- unique(fullrelevant2[,2])[order(unique(fullrelevant2[,2]))])
colnames(dt) <- c("subject","activity")

# Create a table of averages
averages <- ddply(fullrelevant2,c("V1","V1.1"),colwise(mean))
colnames(averages)[1] <- "subject"
colnames(averages)[2] <- "activity"

# Write to File
write.table(averages,file="averages.txt",row.names=FALSE)



