##-------------------------------------------------------------------------------
## load_twin_features: load the EEG feature set and return as data frame
##
## Syntax: dfData <- load_twin_features(file_name)
##
## Inputs: 
##     file_name - name of file
##
## Outputs: 
##     dfData - feature set as data frame
##
## REQUIRES:
##       nothing!
##

## John M. O' Toole, University College Cork
## Started: 19-10-2018
##
## last update: Time-stamp: <2018-10-22 16:49:02 (otoolej)>
##-------------------------------------------------------------------------------
load_twin_features <- function(file_name){

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
