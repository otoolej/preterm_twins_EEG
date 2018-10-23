## Speed up the computation of estimating the ICC thresholds by doing in parallel.
library('parallel')
source('gen_all_ICC_thresholds.R')


## initiate cluster:
no_cores <- detectCores() - 1
cl <- makeCluster(no_cores)


data_types <- c("twins", "mcda", "dcda", "singletons")

## do in parallel:
parLapply(cl, data_types, gen_all_surrogate_limits)


## close cluster
stopCluster(cl)
