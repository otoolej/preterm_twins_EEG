##-------------------------------------------------------------------------------
## compare_ICCs_with_thresholds: compare ICC values with threholds and determine if significant;
##                               write results to a file.
##
## Syntax:  <- compare_ICCs_with_thresholds(cohort="twins")
##
## Inputs: 
##     cohort  - either "twins", "mcda", "dcda", or "singletons"
##
##
## Example:
##     > source('compare_ICCs_with_thresholds.R')
##     > compare_ICCs_with_thresholds("twins")
##     > compare_ICCs_with_thresholds("mcda")
##     > compare_ICCs_with_thresholds("dcda")
##     > compare_ICCs_with_thresholds("singletons")
##
##
## REQUIRES:
##     local functions: set_paths.R


## John M. O' Toole, University College Cork
## Started: 23-10-2018
##
## last update: Time-stamp: <2018-10-23 13:28:22 (otoolej)>
##-------------------------------------------------------------------------------
compare_ICCs_with_thresholds <- function(cohort="twins"){


    source('set_paths.R')
    

    ##-------------------------------------------------------------------
    ## file names for the specific group:
    ##-------------------------------------------------------------------
    if(cohort == "twins"){
        cat("** TWINS \n")
        ficc <- dfNames_fout$twin_icc
        ficc_thres <- dfNames_fout$twin_icc_thres
        fout <- dfNames_fout$twin_icc_sign

    } else if(cohort == "mcda"){
        cat("** MCDA-TWINS \n")
        ficc <- dfNames_fout$mcda_icc
        ficc_thres <- dfNames_fout$mcda_icc_thres
        fout <- dfNames_fout$mcda_icc_sign
        
    } else if(cohort == "dcda"){
        cat("** DCDA-TWINS \n")
        ficc <- dfNames_fout$dcda_icc
        ficc_thres <- dfNames_fout$dcda_icc_thres
        fout <- dfNames_fout$dcda_icc_sign
        
    } else if(cohort == "singletons"){
        cat("** SINGLETONS \n")
        ficc <- dfNames_fout$sing_icc
        ficc_thres <- dfNames_fout$sing_icc_thres
        fout <- dfNames_fout$sing_icc_sign

    }
    
    apply_threshold(ficc, ficc_thres, fout)
}



apply_threshold <- function(ficc, ficc_thres, fout){
    ##-------------------------------------------------------------------
    ## read in files ICCs (from .csv files) and then compare to threshold
    ##-------------------------------------------------------------------

    ## 1. read in files:
    dfICC <- read.csv(ficc)
    dfICC_thres <- read.csv(ficc_thres)

    ## 2. compare with threshold
    dfTwins <- compare_threshold(dfICC, dfICC_thres)

    ## 3. write results to another .csv file:
    dfICC <- write.csv(dfTwins, fout, row.names=FALSE)
}



compare_threshold <- function(dfICC, dfSurr){
    ##-------------------------------------------------------------------
    ## if ICC is >ICC_threshold then TRUE; otherwise FALSE
    ##-------------------------------------------------------------------
    time.points <- names(dfICC)
    time.points <- time.points[ ! time.points %in% c("X", "feature")]

    cnames <- colnames(dfSurr)
    cnames <- gsub("_2nd", "_32weeks", cnames)
    cnames <- gsub("_3rd", "_35weeks", cnames)
    colnames(dfSurr) <- cnames
    
    N.tps <- length(time.points)
    all_feats <- dfICC$feature
    N.feats <- length(all_feats)

    feature <- dfSurr$feature
    dfReturn <- data.frame(feature)

    for(nn in 1:N.tps){
        curr.time.point <- time.points[nn]


        curr.ICCs <- vector('numeric', 0)
        sig.ICC <- vector('logical', 0)
        ip <- 1
        for(pp in 1:N.feats){
            icode <- match(dfICC$feature[pp],  dfSurr$feature)
            if(!is.na(icode)){
                ## cat(sprintf("%d, %d,  | %s | %s |\n", pp, icode, dfICC$feature[pp], dfSurr$feature[icode]))
                ## cat(sprintf("ICC/thres = %f / %f\n", dfICC[pp, curr.time.point], 
                ##             dfSurr[icode, curr.time.point]))

                curr.ICCs[ip] <- dfICC[pp, curr.time.point]
                if(dfICC[pp, curr.time.point] > dfSurr[icode, curr.time.point]){
                    sig.ICC[ip] <- TRUE
                } else {
                    sig.ICC[ip] <- FALSE
                }
                ip <- ip + 1
            }
        }
        dfReturn[[curr.time.point]] <- curr.ICCs
        chead <- paste(curr.time.point, "_SIG", sep="")
        dfReturn[[chead]] <- sig.ICC
        
    }
    return(dfReturn)


}

