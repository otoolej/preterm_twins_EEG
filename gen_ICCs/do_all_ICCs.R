##-------------------------------------------------------------------------------
## do_all_ICCs: generate ICCs at the 3 time points for the twins data set
##
## Syntax: do_all_ICCs(dfFeats, fname_out)
##
## Inputs: 
##     dfFeats, fname_out - 
##
##
## Example:
##     
##

## John M. O' Toole, University College Cork
## Started: 19-10-2018
##
## last update: Time-stamp: <2018-10-22 11:39:57 (otoolej)>
##-------------------------------------------------------------------------------
do_all_ICCs <- function(dfFeats, fname=NA){


    ##-------------------------------------------------------------------
    ## 1. EEG in first few days after birth [early time-point]
    ##-------------------------------------------------------------------
    ICCnoGA <- cal_ICC(dfFeats, 0, "early")
    ICCwithGA <- cal_ICC(dfFeats, 1, "early")


    ##-------------------------------------------------------------------
    ## load the data for the follow-up EEGs [2nd & 3rd time-points]
    ##-------------------------------------------------------------------
    ICCnoGA_32wks <- cal_ICC(dfFeats, 0, "2nd")
    ICCwithGA_32wks <- cal_ICC(dfFeats, 1, "2nd")

    ICCnoGA_35wks <- cal_ICC(dfFeats, 0, "3rd")
    ICCwithGA_35wks <- cal_ICC(dfFeats, 1, "3rd")



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
        write.csv(de, fname)
    }
}
