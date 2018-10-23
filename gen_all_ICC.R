##-------------------------------------------------------------------------------
## gen_all_ICC: calculate ICCs for the twins and singletons, for the 3-timepoints
##              with and without gestational age. Writes output to .csv files.
##
## Syntax:  gen_all_ICC()
##
##
## Example:
##     > source('gen_all_ICC.R')
##     > gen_all_ICC()
##
##
## REQUIRES:
##     lme4 (version 1.1.15)
##     plyr (version 1.8.4)
##
##     and local functions:
##             gen_ICCs/load_twin_features.R
##             gen_ICCs/do_all_ICCs.R
##             gen_ICCs/cal_ICC.R
##             gen_ICCs/estimate_ICC.R


## John M. O' Toole, University College Cork
## Started: 22-10-2018
##
## last update: Time-stamp: <2018-10-22 17:50:28 (otoolej)>
##-------------------------------------------------------------------------------
gen_all_ICC <- function(){

    ##-------------------------------------------------------------------
    ## load libraries and local files:
    ##-------------------------------------------------------------------
    require(lme4)
    require(plyr)

    source('set_paths.R')
    source(paste(r_files_dir, 'load_twin_features.R', sep=""))
    source(paste(r_files_dir, 'do_all_ICCs.R', sep=""))
    source(paste(r_files_dir, 'cal_ICC.R', sep=""))
    source(paste(r_files_dir, 'estimate_ICC.R', sep=""))


    ##-------------------------------------------------------------------
    ## 1.load the data for twins:
    ##-------------------------------------------------------------------
    dfFeats <- load_twin_features(dfNames_fin$twin_feats)

    ## subsets for MCDA and DCDA infants:
    dfFeats.MCDA <- droplevels( subset(dfFeats, (twinType %in% "MCDA")) )
    dfFeats.DCDA <- droplevels( subset(dfFeats, (twinType %in% "DCDA")) )


    ##-------------------------------------------------------------------
    ## 2. do for all twins, then MCDA and DCDA subsets: 
    ##-------------------------------------------------------------------
    do_all_ICCs(dfFeats, dfNames_fout$twin_icc)
    do_all_ICCs(dfFeats.MCDA, dfNames_fout$mcda_icc)
    do_all_ICCs(dfFeats.DCDA, dfNames_fout$dcda_icc)


    ##-------------------------------------------------------------------
    ## 3. same analysis for singletons:
    ##-------------------------------------------------------------------
    ## load the data:
    dfFeatsSing <- load_twin_features(dfNames_fin$sing_feats)

    ## estimate the ICCs:
    do_all_ICCs(dfFeatsSing, dfNames_fout$sing_icc)

}
