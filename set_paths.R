##-------------------------------------------------------------------
## set local directories:
##-------------------------------------------------------------------

## 1. paths
data_dir <- './data/'
r_files_dir <- './gen_ICCs/'
icc_results <- paste(data_dir, 'ICC_results/', sep='')


##-------------------------------------------------------------------
## set files:
##-------------------------------------------------------------------

## 2. file names for generate ICC values and thresholds:
dfNames_fout <- data.frame(twin_icc="all_twins_ICC.csv",
                           mcda_icc="mcda_ICC.csv",
                           dcda_icc="dcda_ICC.csv",
                           sing_icc="singletons_ICC.csv",
                           twin_icc_thres="all_twins_ICC_threshold.csv",
                           mcda_icc_thres="mcda_ICC_threshold.csv",
                           dcda_icc_thres="dcda_ICC_threshold.csv",
                           sing_icc_thres="singletons_ICC_threshold.csv",
                           twin_icc_sign="all_twins_ICC_sign.csv",
                           mcda_icc_sign="mcda_ICC_sign.csv",
                           dcda_icc_sign="dcda_ICC_sign.csv",
                           sing_icc_sign="singletons_ICC_sign.csv")



## files names feature set file names:
dfNames_fin <- data.frame(twin_feats="all_features_twins.csv",
                          sing_feats="all_features_singletons.csv")


## 3. append paths to files:
for(n in 1:length((dfNames_fout))){
    dfNames_fout[, n] <- paste(icc_results, dfNames_fout[, n], sep="")
}
for(n in 1:length((dfNames_fin))){
    dfNames_fin[, n] <- paste(data_dir, dfNames_fin[, n], sep="")
}
