library('parallel')
source('gen_all_surrogate_limits.R')

# Calculate the number of cores
no_cores <- detectCores() - 1
# Initiate cluster
cl <- makeCluster(no_cores)


data_types <- c("twins", "mcda", "dcda", "singletons")

parLapply(cl, data_types, gen_all_surrogate_limits)


stopCluster(cl)
