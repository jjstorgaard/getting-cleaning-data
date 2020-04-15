Here follows a description of the analysis carried out in the script run_analysis.R

The first block (after the loading of libraries) of code extracts all variable names detailed in the file features.txt which are mean and standard deviation values. Their corresponding numbers are then used to select only the relevant variables for import from the datasets.

In the second block, the relavant data is imported along with the lists of subjects and activities, which correspond to the observations in the imported data.

In the third block, the lists of subjects and activities are added to the left of the other variables in the two datasets.

The fourth block focuses on making the variable names in the two datasets readable by replacing hard-to-read code with more intuitive keywords. camCase has been used and long words shortened to immediately recognisable abbreviations where possible.

In the fifth block, the training and test data sets are combined into one. A new dataset is then created containing the average value for each variable per subject and activity, i.e. there is only one, average value for a given variable, subject and activity rather than multiple observations for one subject and activity.