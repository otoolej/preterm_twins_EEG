##-------------------------------------------------------------------------------
## load_twin_features: load the EEG feature set for the twins (return as data frame)
##
## Syntax: dfData <- load_twin_features(file_name)
##
## Inputs: 
##     file_name - 
##
## Outputs: 
##     dfData - 
##
## Example:
##     
##

## John M. O' Toole, University College Cork
## Started: 19-10-2018
##
## last update: Time-stamp: <2018-10-22 11:11:42 (otoolej)>
##-------------------------------------------------------------------------------
load_twin_features <- function(file_name="data/all_features_twins.csv"){

    ## 1. read in features from .csv file:
    dfFeats <- read.csv(file=file_name, header=TRUE, sep=",")

    ## 2. set to factors if necessary:
    dfFeats$babyID <- as.factor(dfFeats$babyID)
    dfFeats$twinID <- as.factor(dfFeats$twinID)
    dfFeats$EEGtime <- as.factor(dfFeats$EEGtime)
    dfFeats$featName <- as.factor(dfFeats$featName)            
    if("twinID" %in% colnames(dfFeats)){
        dfFeats$twinID <- as.factor(dfFeats$twinID)
    }
    dfFeats <- droplevels(dfFeats)

    
    str(dfFeats)
    return(dfFeats)
}
