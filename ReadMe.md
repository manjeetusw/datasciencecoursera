Code Book

This document describes the code inside run_analysis.R script file.

The code is splitted by the steps:

Step0: Load all necessary packages

Step1: Load train and test txt files. Change the column name of activity and subject datasets to read as 'ActivityCode' and 'SubjectCode'.Combine the train and test datasets using 'rbind' to create 'data_main' dataset. The result of this step is 'data_main' data frame with 10299 observations and 563 variables.

Step2: Create data_main_skinny dataset from the data_main using mean and std columns.The result of this step is 'data_main_skinny' with 10299 observations 'SubjectCode', ActivityCode, all columns related to mean and std 
	 
Step3: Rename the columnb(variable) names with the descriptive names as present in the features dataset.

Step4: Rename the Activity Codes with the descriptive names as present in the activity_label dataset.

Step5: Add average for the variables for each subject and activity as new columns to 'data_main_skinny' dataset. Met the data using id as SubjectCode and ActivityCode while using the other 2 variables and measures.Dcast the data_main_skinny data using ActivityCode,SubjectCode for variable and mean
       			
Notes:
The script load all required packages provided they have been loaded on the machine.
The script assumes that the current working directory is set to the main folder UCI HAR Dataset which contains all the datasets.
The script execute all steps as listed above and then prints the final tidyData.
The script finally writes down the tidyData in to a text file in the current working directory.

tidyData - sample data [Total 180 observations 4 variable]

head(tidyData)
ActivityCode SubjectCode  meanValue   stdValue
1       LAYING           1 -0.6205376 -0.4825845
2       LAYING           2 -0.6554136 -0.5097216
3       LAYING           3 -0.6624198 -0.5092233
4       LAYING           4 -0.6596454 -0.5175184
5       LAYING           5 -0.6531094 -0.5164585
6       LAYING           6 -0.6385509 -0.5043518
