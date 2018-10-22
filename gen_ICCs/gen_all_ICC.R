##-------------------------------------------------------------------
## load libraries and local files:
##-------------------------------------------------------------------
require(lme4)
require(plyr)

## load all .R files in this directory:
## r_files_dir <- './gen_ICCs/'
## r_files <- list.files(path=r_files_dir, pattern='*.R', full.names=TRUE)
## sapply(r_files, source) ##, .GlobalEnv)
source('set_paths.R')
source(paste(r_files_dir, 'load_twin_features.R', sep=""))
source(paste(r_files_dir, 'do_all_ICCs.R', sep=""))
source(paste(r_files_dir, 'cal_ICC.R', sep=""))
source(paste(r_files_dir, 'estimate_ICC.R', sep=""))


##-------------------------------------------------------------------
## 1.load the data for twins:
##-------------------------------------------------------------------
fname <- paste(data_dir, 'all_features_twins.csv', sep="")
dfFeats <- load_twin_features(fname)

## subsets for MCDA and DCDA infants:
dfFeats.MCDA <- droplevels( subset(dfFeats, (twinType %in% "MCDA")) )
dfFeats.DCDA <- droplevels( subset(dfFeats, (twinType %in% "DCDA")) )


##-------------------------------------------------------------------
## 2. do for all twins, then MCDA and DCDA subsets: 
##-------------------------------------------------------------------
do_all_ICCs(dfFeats, paste(icc_results, "all_twins_ICC_features.csv", sep=""))
do_all_ICCs(dfFeats.MCDA, paste(icc_results, "mcda_twins_ICC_features.csv", sep=""))
do_all_ICCs(dfFeats.DCDA, paste(icc_results, "dcda_twins_ICC_features.csv", sep=""))


##-------------------------------------------------------------------
## 3. same analysis for singletons:
##-------------------------------------------------------------------
## load the data:
fname <- paste(data_dir, 'all_features_singletons.csv', sep="")
dfFeatsSing <- load_twin_features(fname)

## estimate the ICCs:
do_all_ICCs(dfFeatsSing, paste(icc_results, "singletons_ICC_features.csv", sep=""))
