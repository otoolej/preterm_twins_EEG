read_compare_ICC_surr_threshold <- function(){


    ##-------------------------------------------------------------------
    ## ALL twins
    ##-------------------------------------------------------------------
    cat("** TWINS \n")
    apply_threshold("all_surr_twins_v2.csv","all_ICC_features_log_noIUGRs_v2.csv",
                    "all_ICC_twins_withTHRES_v2.csv")
    
    ##-------------------------------------------------------------------
    ## MCDA twins
    ##-------------------------------------------------------------------
    cat("** MCDA twins \n")    
    apply_threshold("all_surr_twins_MCDA_v2.csv","mcda_ICC_features_log_noIUGRs_v2.csv",
                    "mcda_ICC_twins_withTHRES_v2.csv")


    ##-------------------------------------------------------------------
    ## DCDA twins
    ##-------------------------------------------------------------------
    cat("** DCDA twins \n")        
    apply_threshold("all_surr_twins_DCDA_v2.csv","dcda_ICC_features_log_noIUGRs_v2.csv",
                    "dcda_ICC_twins_withTHRES_v2.csv")
    
    
    ##-------------------------------------------------------------------
    ## singletons twins
    ##-------------------------------------------------------------------
    cat("** SINGLETONS \n")        
    apply_threshold("all_surr_singletons_v2.csv","all_ICC_features_log_SINGLETONS_v2.csv",
                    "all_ICC_singletons_withTHRES_v2.csv")


}


apply_threshold <- function(fsurr,ficc,fout){

    ddir_surr <- "/home/otoolej/ucc/software/twin_study_Rhodri/data/ICC_results/surrogate_threshold_values/";
    ddir <- "/home/otoolej/ucc/software/twin_study_Rhodri/data/ICC_results/";

    
    fnameCSV <- paste(ddir_surr,fsurr,sep="")
    drSurr <- read.csv(fnameCSV)

    fnameCSV <- paste(ddir,ficc,sep="")
    drICC <- read.csv(fnameCSV)

    drTwins <- compare.threshold(drICC,drSurr)

    fnameCSV <- paste(ddir,fout,sep="")
    drICC <- write.csv(drTwins,fnameCSV)
}



compare.threshold <- function(drICC,drSurr){
    ##-------------------------------------------------------------------
    ## combine functions here
    ##-------------------------------------------------------------------

    time.points <- names(drICC)
    time.points <- time.points[ ! time.points %in% c("X","feature")]

    cnames <- colnames(drSurr)
    cnames <- gsub("_2nd","_32weeks",cnames)
    cnames <- gsub("_3rd","_35weeks",cnames)
    colnames(drSurr) <- cnames
    
    N.tps <- length(time.points)
    all_feats <- drICC$feature
    N.feats <- length(all_feats)

    feature <- drSurr$feature
    drReturn <- data.frame(feature)

    for(nn in 1:N.tps){
        curr.time.point <- time.points[nn]


        curr.ICCs <- vector('numeric',0)
        sig.ICC <- vector('logical',0)
        ip <- 1
        for(pp in 1:N.feats){
            icode <- match(drICC$feature[pp], drSurr$feature)
            if(!is.na(icode)){
                ## cat(sprintf("%d,%d, | %s | %s |\n",pp,icode,drICC$feature[pp],drSurr$feature[icode]))
                ## cat(sprintf("ICC/thres = %f / %f\n",drICC[pp,curr.time.point],
                ##             drSurr[icode,curr.time.point]))

                curr.ICCs[ip] <- drICC[pp,curr.time.point]
                if(drICC[pp,curr.time.point]>drSurr[icode,curr.time.point]){
                    sig.ICC[ip] <- TRUE
                } else {
                    sig.ICC[ip] <- FALSE
                }
                ip <- ip + 1
            }
        }
        drReturn[[curr.time.point]] <- curr.ICCs
        chead <- paste(curr.time.point,"_SIG",sep="")
        drReturn[[chead]] <- sig.ICC
        
    }
    return(drReturn)


}

