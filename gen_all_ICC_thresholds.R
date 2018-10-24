##-------------------------------------------------------------------------------
## gen_all_ICC_thresholds: generate lower-threshold for ICCs using a surrogate-data
##                         approach
##
## Syntax: drT <- gen_all_ICC_thresholds(cohort="twins")
##
## Inputs: 
##     cohort  - either "twins", "mcda", "dcda", or "singletons"
##
##
## Example:
##     > source('gen_all_ICC_thresholds.R')
##     > gen_all_ICC_thresholds("twins")
##     > gen_all_ICC_thresholds("mcda")
##     > gen_all_ICC_thresholds("dcda")
##     > gen_all_ICC_thresholds("singletons")
##
##   or can run this in parallel by using:
##
##    > require('parallel')
##    > no_cores <- detectCores() - 1
##    > cl <- makeCluster(no_cores)
##    > data_types <- c("twins", "mcda", "dcda", "singletons")
##    > parLapply(cl, data_types, gen_all_ICC_thresholds)
##    > stopCluster(cl)
##
## REQUIRES:
##     lme4 (version 1.1.15)
##     plyr (version 1.8.4)
##
##     and local functions:
##             set_paths.R
##             gen_ICCs/load_twin_features.R
##             gen_ICCs/do_all_ICCs_surrogate.R
##             gen_ICCs/cal_ICC_threshold.R
##             gen_ICCs/estimate_ICC.R
## 


## John M. O' Toole, University College Cork
## Started: 22-10-2018
##
## last update: Time-stamp: <2018-10-23 17:40:58 (otoolej)>
##-------------------------------------------------------------------------------
gen_all_ICC_thresholds <- function(cohort = "twins"){

    ##-------------------------------------------------------------------
    ## load libraries and local files:
    ##-------------------------------------------------------------------
    require(lme4)
    require(plyr)
    source('set_paths.R')
    source(paste(r_files_dir, 'load_twin_features.R', sep=""))
    source(paste(r_files_dir, 'do_all_ICCs_surrogate.R', sep=""))
    source(paste(r_files_dir, 'cal_ICC_threshold.R', sep=""))
    source(paste(r_files_dir, 'estimate_ICC.R', sep=""))


    N_iter <- 1000

    ## only do for 1 group at a time (as computational slow):
    if((cohort %in% c("twins","mcda","dcda"))){
        ##-------------------------------------------------------------------
        ## load the twin data:
        ##-------------------------------------------------------------------
        dfFeats <- load_twin_features(dfNames_fin$twin_feats)

        ##-------------------------------------------------------------------
        ## subsets for MCDA and DCDA infants
        ##-------------------------------------------------------------------
        if(cohort == "mcda"){
            dfFeats.MCDA <- droplevels( subset(dfFeats,(twinType %in% "MCDA")) )
            fname <- dfNames_fout$mcda_icc_thres
        } else if(cohort == "dcda") {
            dfFeats <- droplevels( subset(dfFeats,(twinType %in% "DCDA")) )
            fname <- dfNames_fout$dcda_icc_thres
        } else {
            fname <- dfNames_fout$twin_icc_thres
        }

        
    } else if(cohort=="singletons"){ 
        ##-------------------------------------------------------------------
        ##  load the SINGLETONS data:
        ##-------------------------------------------------------------------
        dfFeats <- load_twin_features(dfNames_fin$sing_feats)
        fname <- dfNames_fout$sing_icc_thres

    }

    ## generate the ICC thresholds:
    do_all_ICCs_surrogate(dfFeats, N_iter, fname)
}
