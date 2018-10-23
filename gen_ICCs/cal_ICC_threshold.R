##-------------------------------------------------------------------------------
## cal_ICC_threshold: estimate cut-off threshold (95th percentile) for zero-level ICC
##
## Syntax: dfICC <- cal_ICC_threshold(dfData, with_GA=1, timepoint="early", N_iter=1000)
##
## Inputs: 
##     dfData     - data frame with feature set
##     with_GA    - control for gestational age, 0=no, 1=yes (default=1)
##     timepoint  - which time-point to analyse: "early", "2nd", or "3rd" (default="early")
##     N_iter     - number of iterations (default=1000)
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
## Started: 22-10-2018
##
## last update: Time-stamp: <2018-10-22 17:01:20 (otoolej)>
##-------------------------------------------------------------------------------
cal_ICC_threshold <- function(dfData, with_GA=1, timepoint="early", N_iter=1000){

    DBverbose <- 1

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
    upper_limit <- vector('numeric', length=N_feats)


    ##-------------------------------------------------------------------
    ## GA in model
    ##-------------------------------------------------------------------
    for(nn in 1:N_feats){
        featureName <- allFeatureNames[nn]

        dfData.sub <- dfData[dfData$featName == featureName, ]
        dfData.sub <- droplevels(dfData.sub)


        ## calculate the mean and SD for the feature:
        feat_est <- log(dfData.sub$feat + 1e-16)
        N <- length(feat_est)
        icc_all <- matrix(,nrow=N_iter)
        mfeat <- mean(feat_est)
        sdfeat <- sd(feat_est)

        ## iterate to generate a distribution of ICC estimates
        for(pp in 1:N_iter){

            ## random feature with similar distribution:
            dfData.sub$feat <- rnorm(N, mean=mfeat, sd=sdfeat)

            ##-------------------------------------------------------------------
            ## estimate the ICC
            ##-------------------------------------------------------------------
            icc_all[pp] <- estimate_ICC(dfData.sub, with_GA, timepoint, 0)
        }

        upper_limit[nn] <- quantile(icc_all, 0.95)

        if(DBverbose){
            print( sprintf("| %s | ICC=%f |", featureName, upper_limit[nn] ))
        }
    }

    ##-------------------------------------------------------------------
    ## collect ICCs and return
    ##-------------------------------------------------------------------
    dfICC <- data.frame(allFeatureNames, upper_limit)
    colnames(dfICC) <- c("feature", "ICC")

    
    return(dfICC)
}
