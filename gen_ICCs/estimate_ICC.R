##-------------------------------------------------------------------------------
## estimate_ICC: linear mixed-effects model to estimate the ICC
##
## Syntax:  icc <- estimate_ICC(drData, with_GA=1, timepoint="early", DBverbose=0)
##
## Inputs:
##     dfData     - data frame with feature set
##     with_GA    - control for gestational age (0=no, 1=yes); default=1
##     timepoint  - which time-point to analyse: "early", "2nd", or "3rd"; default="early"
##     DBverbose  - verbosity 
##
## Outputs: 
##      icc - intra-class correlation
##
## REQUIRES:
##     lme4 (version 1.1.15)


## John M. O' Toole, University College Cork
## Started: 22-10-2018
##
## last update: Time-stamp: <2018-10-22 16:44:38 (otoolej)>
##-------------------------------------------------------------------------------
estimate_ICC <- function(drData, with_GA=1, timepoint="early", DBverbose=0){


    ## 1. define the formula depending on the timepoint and whether to
    ##    to include GA or not:
    if(with_GA == 1){
        
        form <- "1 + GA + (1 | twinID)"
    } else {
        
        form <- "1 +  (1 | twinID)"
    }
    if(timepoint == "early"){
        ## the 'early' timepoint has repeated measures and therefore should
        ## be included in model:
        form <- paste(form, "+ (1 | babyID)", sep=" ")
    }

    form <- reformulate(form, "feat")
    if(DBverbose) cat(sprintf('FULL formula: %s\n', format(form)))


    ## 2. linear mixed model
    pd.feat <- lme4::lmer(form, drData, REML=TRUE)


    ##-------------------------------------------------------------------
    ## 3. estimate ICC from variances
    ##-------------------------------------------------------------------
    dd <- as.data.frame(VarCorr(pd.feat))

    varTwins <- dd[dd$grp == "twinID", "vcov"]


    ## different formulas depending on the model type:
    if(timepoint == "early"){
        
        icc <- varTwins / (dd[dd$grp == "babyID", "vcov"] + varTwins + dd[dd$grp == "Residual", "vcov"])
    } else {

        icc <- varTwins / (varTwins + dd[dd$grp=="Residual","vcov"])
    }
    
    return(icc)
}
