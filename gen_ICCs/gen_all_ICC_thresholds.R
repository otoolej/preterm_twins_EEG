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
##     
##
## Requires: lme4; plyr

## John M. O' Toole, University College Cork
## Started: 22-10-2018
##
## last update: Time-stamp: <2018-10-22 14:58:33 (otoolej)>
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


    N_iter <- 10

    ## only do for 1 group at a time (as computational slow):
    if((cohort %in% c("twins","mcda","dcda"))){
        ##-------------------------------------------------------------------
        ## load the twin data:
        ##-------------------------------------------------------------------
        fname <- paste(data_dir, 'all_features_twins.csv', sep="")
        dfFeats <- load_twin_features(fname)

        ##-------------------------------------------------------------------
        ## subsets for MCDA and DCDA infants
        ##-------------------------------------------------------------------
        if(cohort == "mcda"){
            dfFeats.MCDA <- droplevels( subset(dfFeats,(twinType %in% "MCDA")) )
            fname <- "mcda_ICC_threshold.csv"
        } else if(cohort == "dcda") {
            dfFeats <- droplevels( subset(dfFeats,(twinType %in% "DCDA")) )
            fname <- "dcda_ICC_threshold.csv"
        } else {
            fname <- "all_twins_ICC_threshold.csv"
        }

        
    } else if(cohort=="singletons"){ 
        ##-------------------------------------------------------------------
        ##  load the SINGLETONS data:
        ##-------------------------------------------------------------------
        fname <- paste(data_dir, 'all_features_singletons.csv', sep="")
        dfFeatsSing <- load_twin_features(fname)
        fname <- "singletons_ICC_threshold.csv"

    }

    ## generate the ICC thresholds:
    do_all_ICCs_surrogate(dfFeats, N_iter, paste(icc_results, fname, sep=""))
}
