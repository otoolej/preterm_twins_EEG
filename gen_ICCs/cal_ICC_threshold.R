##-------------------------------------------------------------------------------
## cal_ICC_threshold: estimate cut-off threshold (95th percentile) for zero-level ICC
##
## Syntax: iccSt <- cal_ICC_threshold(drData, with_GA=1, timepoint="early", N_iter=500)
##
## Inputs: 
##     drData, with_GA=1, timepoint="early", N_iter=500 - 
##
## Outputs: 
##     iccSt - 
##
## Example:
##     
##
## Requires: lme4

## John M. O' Toole, University College Cork
## Started: 22-10-2018
##
## last update: Time-stamp: <2018-10-22 14:44:53 (otoolej)>
##-------------------------------------------------------------------------------
cal_ICC_threshold <- function(drData, with_GA=1, timepoint="early", N_iter=500){

    DBverbose <- 1

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
    upper_limit <- vector('numeric', length=N_feats)


    ##-------------------------------------------------------------------
    ## GA in model
    ##-------------------------------------------------------------------
    for(nn in 1:N_feats){
        featureName <- allFeatureNames[nn]

        ##rm(drData.sub)
        drData.sub <- drData[drData$featName == featureName, ]
        drData.sub <- droplevels(drData.sub)


        ## calculate the mean and SD for the feature:
        feat_est <- log(drData.sub$feat + 1e-16)
        N <- length(feat_est)
        icc_all <- matrix(,nrow=N_iter)
        mfeat <- mean(feat_est)
        sdfeat <- sd(feat_est)

        ## iterate to generate a distribution of ICC estimates
        for(pp in 1:N_iter){

            ## random feature with similar distribution:
            drData.sub$feat <- rnorm(N, mean=mfeat, sd=sdfeat)

            ##-------------------------------------------------------------------
            ## estimate the ICC
            ##-------------------------------------------------------------------
            icc_all[pp] <- estimate_ICC(drData.sub, with_GA, timepoint, 0)
        }

        upper_limit[nn] <- quantile(icc_all, 0.95)

        if(DBverbose){
            print( sprintf("| %s | ICC=%f|", featureName, upper_limit[nn] ))
        }
    }

    iccSt <- data.frame(allFeatureNames, upper_limit)
    colnames(iccSt) <- c("feature", "ICC")

    
    return(iccSt)
}
