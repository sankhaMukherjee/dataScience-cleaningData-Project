library(plyr)
library(dplyr)

#-----------------------------------------------------------
# This data is common to all files. this contains the names
# of the 562 dimensions in the observational vectors, and 
# thus forms the features of the observations. 
# ----------------------------------------------------------
features <- read.csv("UCI HAR Dataset/features.txt", header=FALSE, sep="")
features <- as.character(features$V2)
features <- gsub("\\(", "", features)
features <- gsub("\\)", "", features)
features <- gsub(",",   "", features)

#-----------------------------------------------------------
# This data is also common to all the files. This contains 
# the activity of the user (such as WALKING etc.)
#-----------------------------------------------------------
activityLabels <- read.csv("UCI HAR Dataset/activity_labels.txt", header=FALSE, sep="")
names(activityLabels) <- c("id", "label")

#---------------------------------------------------------
# This function takes a filename for the dataset we want
# to work on, and returns the dataframe with only columns 
# containing mean and the standard deviations in them. 
#
# This way, the dataframe will not 
# contain a lot of frivolous data. The information 
# required for the function are the following:
# 
#  dataFile: This is the name of the file containing the 
#     vectors of the movement
#  labelFile: This is a file containing the activity
#     label for each of the vectors provided corresponding 
#     to the activity performed.
#  subjectFile: This file corresponds to the subject id 
#     of the person performing the activity
#  features: these are the names of the different elements
#     of the vector available within the data file 
#  activityLables: this is the dataframe that associates an 
#     activity id to an activity. (e.g. WALKING has an i.d.
#     of 1).
# -------------------------------------------------------
createDataSet <- function( dataFile, labelFile, subjectFile, features, activityLables) {
    subjects <- read.csv(subjectFile, header=FALSE, sep="")
    labels   <- read.csv(labelFile  , header=FALSE, sep="")
    data     <- read.csv(dataFile   , header=FALSE, sep="", col.names=features)
    
    # We also need to extract only the mean and standard deviation 
    # `grepl(a,b)` returns TRUE of `a` is a substring of `b`, and 
    #    FALSE otherwise
    f1 = function(val) { grepl("mean", val) }
    f2 = function(val) { grepl("std",  val) }
    f3 = function(val) { grepl("Mean", val) }
    selectFeatures =  sapply(features, f1, USE.NAMES=FALSE) | 
                      sapply(features, f2, USE.NAMES=FALSE) |
                      sapply(features, f3, USE.NAMES=FALSE)
    
    # get rid of stuff we dont need ...
    data <- data[,selectFeatures]
    
    # Let us also add the activity ...
    # Rememebr that we can only add vectors 
    # and neither factors nor lists here. Otherwise we will 
    # have trouble with the rbind operator
    data$activity <- as.character(factor(labels$V1 , label = activityLabels$label))
    
    # And the subjects ni the experiment if we ever need that ...
    data$subjects <- subjects$V1
    
    data
    
}

test <- createDataSet("UCI HAR Dataset/test/X_test.txt", 
                      "UCI HAR Dataset/test/y_test.txt", 
                      "UCI HAR Dataset/test/subject_test.txt", 
                      features, activityLables)

train <- createDataSet("UCI HAR Dataset/train/X_train.txt", 
                      "UCI HAR Dataset/train/y_train.txt", 
                      "UCI HAR Dataset/train/subject_train.txt", 
                      features, activityLables)

# Now that the two dataframes are ready, lets combine them
total <- rbind(train, test)

# Finally we write the CSV file containing the data ...
write.csv(total, "total.csv")

# Let us summarize the result, and write the data to file ...
summary <- total %>% group_by(subjects, activity) %>% summarise_each(funs(mean))
write.csv(summary, "summary.csv")
