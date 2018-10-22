##-------------------------------------------------------------------------------
## cal_ICC: estimates ICCs for the early time point
##
## Syntax: dfICC <- cal_ICC(drData, with_GA=0, fname="ICC_features_no_GA.csv")
##
## Inputs: 
##     drData, with_GA=0, fname="ICC_features_no_GA.csv" - 
##
## Outputs: 
##     dfICC - 
##
## Example:
##     
##

## John M. O' Toole, University College Cork
## Started: 19-10-2018
##
## last update: Time-stamp: <2018-10-22 13:09:51 (otoolej)>
##-------------------------------------------------------------------------------
cal_ICC <- function(drData, with_GA=0, timepoint="early", fname=NA){

    DBverbose <- 0

    if(timepoint == "early"){
        ##-------------------------------------------------------------------
        ## include only early time points
        ##-------------------------------------------------------------------
        ## remove follow-up EEGs (at 32 and 35 weeks):
        drData <- drData[drData$EEGtime != "2nd", ]
        drData <- drData[drData$EEGtime != "3rd", ]
        ## change units of time from hours to days:
        drData$EEGtime <- (as.numeric(as.character(drData$EEGtime)))/24

    } else {
        ##-------------------------------------------------------------------
        ## or if the 32 week or 35 week time point:
        ##-------------------------------------------------------------------

        drData <- subset(drData,EEGtime %in% timepoint)
    }
    drData <- droplevels(drData)

    ##-------------------------------------------------------------------
    ## select feature
    ##-------------------------------------------------------------------
    allFeatureNames <- levels(drData$featName)
    N_feats <- length(allFeatureNames)
    icc <- matrix(, nrow=N_feats)

    
    
    ##-------------------------------------------------------------------
    ## GA in model
    ##-------------------------------------------------------------------
    for(nn in 1:N_feats){
        featureName <- allFeatureNames[nn]

        ##rm(drData.sub)
        drData.sub <- drData[drData$featName == featureName, ]
        drData.sub <- droplevels(drData.sub)

        drData.sub$feat <- log(drData.sub$feat + 1e-16)
        
        
        ##-------------------------------------------------------------------
        ## estimate the ICC
        ##-------------------------------------------------------------------
        icc[nn] <- estimate_ICC(drData.sub, with_GA, timepoint, DBverbose)
        print( sprintf("| %s | ICC=%f|", featureName, icc[nn]) )

    }

    ##-------------------------------------------------------------------
    ## collect ICCs and write to .csv file
    ##-------------------------------------------------------------------
    iccSt <- data.frame(allFeatureNames, icc)
    colnames(iccSt) <- c("feature", "ICC")

    ## write to .csv file
    if(!is.na(fname)){
        ddir <- "./data/ICC_results/";
        fnameCSV <- paste(ddir, fname, sep="")

        write.csv(iccSt, fnameCSV, row.names=FALSE)
    }

    return(iccSt)
}



