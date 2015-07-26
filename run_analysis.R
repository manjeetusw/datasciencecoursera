# Assuming the necessary packages to execute the below code are already installed.
# R packages such as dplyr, reshape2, melt are installed
lapply(.packages(all.available = TRUE), function(xx) library(xx,     character.only = TRUE)) 
# Assuming the current working directory has been set to the folder UCI HAR Dataset
# which has 2 folders 'test', 'train' and files 'activity_labels.txt', 'features.txt',
# 'features_info.txt', 'README.txt'

# Folder path for the test folder that contains one folder 'Inertial Signals' and 3 files
# 'subject_test.txt', 'X_test.txt' and 'y_test.txt'
testPath= paste(getwd(),"/test",sep="")

# Folder path for the train folder that contains one folder 'Inertial Signals' and 3 files
# 'subject_train.txt', 'X_train.txt' and 'y_train.txt'
trainPath=paste(getwd(),"/train",sep="")

# STEP 1:::::: MERGE the train and test datasets (train_main, test_main)

# GET 'test' datasets
test_x=read.table(paste(testPath,"/X_test.txt",sep="")) # read X_test.txt file
test_y_activity=read.table(paste(testPath,"/y_test.txt",sep="")) # read y_test.txt file
test_subject=read.table(paste(testPath,"/subject_test.txt",sep="")) # read subject_test.txt file
     # Merge all 'test' datasets
      names(test_subject)=c("SubjectCode")
      names(test_y_activity)=c("ActivityCode")
      
      #test_main=cbind(rename(test_subject,SubjectCode=V1),rename(test_y_activity,ActivityCode=V1),test_x)
      test_main=cbind(test_subject,test_y_activity,test_x)

# GET 'train' datasets
train_subject=read.table(paste(trainPath,"/subject_train.txt",sep="")) # read subject_train.txt file
train_y_activity=read.table(paste(trainPath,"/y_train.txt",sep="")) # read y_train.txt file
train_x=read.table(paste(trainPath,"/X_train.txt",sep="")) # read X_train.txt file
    # Merge all 'train' datasets
      names(train_subject)=c("SubjectCode")
      names(train_y_activity)=c("ActivityCode")
      train_main=cbind(train_subject,train_y_activity,train_x)

# Merge test and train Datasets
data_main=rbind(train_main,test_main)
  
# STEP 2:::::: Getting mesaurements on the mean and standard deviation columns (variables)

  # Read features.txt
  features=read.table("features.txt")
  # get count of columns from features dataset that contains the keyword 'std'
  count(features[grep("std",features$V2),])
  #get count of columnsfrom features dataset that contains the keyword 'mean'
  count(features[grep("mean",features$V2),])
  
  # get the name of all columns that contains the keyword 'mean'
  meancols=features[grep("mean",features$V2),1]
  # get the name of all columns that contains the keyword 'std'
  stdCols=features[grep("std",features$V2),1]
  
  #Add character 'V' to all elements of vector meancols
  meancolnames=paste("V",meancols,sep="")
  #Add character 'V' to all elements of vector stdcols
  stdcolnames=paste("V",stdCols,sep="")
  #create one vector to contain the names of all mean and std columns
  allcols=c("SubjectCode","ActivityCode",meancolnames,stdcolnames)
  #Create data_main_skinny dataframe from the merged dataset data_main by extracting only mean and standard deviations columns 
  data_main_skinny=data_main[,allcols]


#Step 3::::::: Get Descriptive Labels for variables (V1, V2, V3....)
  #Add character 'V' to all feature dataframe column 1 and create a new vector
  vv=paste("V",features$V1,sep="")
  
  #Match the column names of the data_main_skinny dataframe with the vector vv
  matchedFeatureNo4label=match(names(data_main_skinny),vv)
  #Remove entries (numeric items) where there was no match (NA)
  matchedFeatureNo4label=matchedFeatureNo4label[!is.na(matchedFeatureNo4label)]
  # for the matched col numbers get the descriptive column names for the data frame
  newColnames=features[features$V1 %in% matchedFeatureNo4label,2]
  # change the data type of the descriptive column names to character
  newColnames=as.character(newColnames)
  # Add first two column names to the newColnames vector
  newColnames=c("SubjectCode","ActivityCode",newColnames)

  #Apply the descriptive variable(column) names to
  names(data_main_skinny)=newColnames
    
#Step 4::::::: Get activity  names for the numbers in the data frame
activity_labels=read.table("activity_labels.txt")
ActivityLabel=activity_labels[,2][data_main_skinny$ActivityCode]
#apply the activity names to the code in the data frame
data_main_skinny$ActivityCode=ActivityLabel


#STEP 5:::::: Tidy DataSet

#Get column names which has 'mean' in their name
colMean=grep("+mean+",colnames(data_main_skinny))
#Get all column names which has 'std' in their name
colStd= grep("+std+",colnames(data_main_skinny))

#Add mean column in dataframe
data_main_skinny$meanValue=apply(data_main_skinny[,colMean],1,function(x) mean(x))
#Add std column in dataframe
data_main_skinny$stdValue=apply(data_main_skinny[,colStd],1,function(x) mean(x))

#tidy up the data (Keeping first 2 columns (SubjectCode, ActivityCode), adding the new 2 columns(meanValue,stdValue)
# and excluding all others to result in 4 columns)
data_main_skinny=data_main_skinny[,c("SubjectCode","ActivityCode","meanValue","stdValue")]


#Melt data set from previous step
meltedData=melt(data_main_skinny,id=c("SubjectCode","ActivityCode"),measure.vars = c("meanValue","stdValue"))
# Create tidy data set
tidyData= dcast(meltedData,ActivityCode + SubjectCode ~ variable,mean)
print(tidyData)
