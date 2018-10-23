##-------------------------------------------------------------------------------
## cal_ICC: estimates ICCs for the early time point
##
## Syntax: dfICC <- cal_ICC(dfData, with_GA=1, timepoint="early")
##
## Inputs: 
##     dfData     - data frame with feature set
##     with_GA    - control for gestational age (0=no, 1=yes); default=1
##     timepoint  - which time-point to analyse: "early", "2nd", or "3rd"; default="early"
##
##
## Outputs: 
##     dfICC - data frame with ICC threshold for each feature
##
##     
##
## REQUIRES:
##     lme4 (version 1.1.15)
##
##     and local functions:
##             gen_ICCs/estimate_ICC.R


## John M. O' Toole, University College Cork
## Started: 19-10-2018
##
## last update: Time-stamp: <2018-10-22 16:32:56 (otoolej)>
##-------------------------------------------------------------------------------
cal_ICC <- function(dfData, with_GA=1, timepoint="early", fname=NA){

    DBverbose <- 0

    if(timepoint == "early"){
        ##-------------------------------------------------------------------
        ## include only early time points
        ##-------------------------------------------------------------------
        ## remove follow-up EEGs (at 32 and 35 weeks):
        dfData <- dfData[dfData$EEGtime != "2nd", ]
        dfData <- dfData[dfData$EEGtime != "3rd", ]
        ## change units of time from hours to days:
        dfData$EEGtime <- (as.numeric(as.character(dfData$EEGtime)))/24

    } else {
        ##-------------------------------------------------------------------
        ## or if the 32 week or 35 week time point:
        ##-------------------------------------------------------------------

        dfData <- subset(dfData,EEGtime %in% timepoint)
    }
    dfData <- droplevels(dfData)

    ##-------------------------------------------------------------------
    ## select feature
    ##-------------------------------------------------------------------
    allFeatureNames <- levels(dfData$featName)
    N_feats <- length(allFeatureNames)
    icc <- matrix(, nrow=N_feats)

    
    
    ##-------------------------------------------------------------------
    ## GA in model
    ##-------------------------------------------------------------------
    for(nn in 1:N_feats){
        featureName <- allFeatureNames[nn]

        dfData.sub <- dfData[dfData$featName == featureName, ]
        dfData.sub <- droplevels(dfData.sub)

        dfData.sub$feat <- log(dfData.sub$feat + 1e-16)
        
        
        ##-------------------------------------------------------------------
        ## estimate the ICC
        ##-------------------------------------------------------------------
        icc[nn] <- estimate_ICC(dfData.sub, with_GA, timepoint, DBverbose)
        print( sprintf("| %s | ICC=%f|", featureName, icc[nn]) )

    }

    ##-------------------------------------------------------------------
    ## collect ICCs and return
    ##-------------------------------------------------------------------
    dfICC <- data.frame(allFeatureNames, icc)
    colnames(dfICC) <- c("feature", "ICC")


    return(dfICC)
}



