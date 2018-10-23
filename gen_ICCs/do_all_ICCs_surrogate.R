##-------------------------------------------------------------------------------
## do_all_ICCs_surrogate: generate ICC threshold for dataframe dfFeats
##
## Syntax:  do_all_ICCs_surrogate(dfFeats, N_iter=1000, fname=NA)
##
## Inputs:
##     dfFeats - data frame with feature set
##     N_iter  - number of iterations (default=1000)
##     fname   - output .csv file (default=NA)
##
##
## REQUIRES:
##     lme4 (version 1.1.15)
##     plyr (version 1.8.4)
##
##     and local functions:
##             gen_ICCs/cal_ICC_threshold.R
##             gen_ICCs/estimate_ICC.R


## John M. O' Toole, University College Cork
## Started: 22-10-2018
##
## last update: Time-stamp: <2018-10-22 16:43:26 (otoolej)>
##-------------------------------------------------------------------------------
do_all_ICCs_surrogate <- function(dfFeats, N_iter=1000, fname=NA){


    ##-------------------------------------------------------------------
    ## 1. EEG in first few days after birth [early time-point]
    ##-------------------------------------------------------------------
    ICCnoGA <- cal_ICC_threshold(dfFeats, 0, "early", N_iter)
    ICCwithGA <- cal_ICC_threshold(dfFeats, 1, "early", N_iter)


    ##-------------------------------------------------------------------
    ## load the data for the follow-up EEGs [2nd & 3rd time-points]
    ##-------------------------------------------------------------------
    ICCnoGA_32wks <- cal_ICC_threshold(dfFeats, 0, "2nd", N_iter)
    ICCwithGA_32wks <- cal_ICC_threshold(dfFeats, 1, "2nd", N_iter)

    ICCnoGA_35wks <- cal_ICC_threshold(dfFeats, 0, "3rd", N_iter)
    ICCwithGA_35wks <- cal_ICC_threshold(dfFeats, 1, "3rd", N_iter)



    ##-------------------------------------------------------------------
    ## merge all ICC into one data frame and write to one .csv file
    ##-------------------------------------------------------------------
    colnames(ICCnoGA) <-   c("feature", "ICC_noGA_early")
    colnames(ICCwithGA) <-   c("feature", "ICC_withGA_early")
    colnames(ICCnoGA_32wks) <-   c("feature", "ICC_noGA_32weeks")
    colnames(ICCwithGA_32wks) <- c("feature", "ICC_withGA_32weeks")
    colnames(ICCnoGA_35wks) <-   c("feature", "ICC_noGA_35weeks")
    colnames(ICCwithGA_35wks) <- c("feature", "ICC_withGA_35weeks")


    de <- join_all(list(ICCnoGA, ICCnoGA_32wks, ICCnoGA_35wks, ICCwithGA, ICCwithGA_32wks, 
                        ICCwithGA_35wks),  by="feature")

    if(!is.na(fname)){
        write.csv(de, fname, row.names=FALSE)
    }
}
