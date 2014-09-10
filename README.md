tidy_data
=========

tidy data final assignment

This github repository holds an R script (run_analysis.R) that will download data from the UCI Machine Learning repository. This data was used to train a support vector machine to recognize human activity using measurement from a smart phone.

See this link for some background information
http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand/

and this site for information about the study and data used
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

The script mentioned will filter the data and create a 'tidy' dataset. For information on what makes a dataset tidy see Hadley Wickham's paper  http://vita.had.co.nz/papers/tidy-data.pdf 

Steps taken to filter and tidy the data are as follows
1. download the data
2. merge the training and test datasets
3. extact all measurements concerning the mean and standard deviation
4. label activities with descriptive names (ie walking, laying etc)
5. label all measurements with descriptive names
6. average the activity measurements for each subject

Use the following command to run the script
Rscript run_analysis.R

The 'tidy' dataset can be read in to R with the following command
data <- read.delim("jlivingstone_tidy_data_final_assign.txt", sep = "\t", as.is=T, check.names=F)
