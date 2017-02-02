paralleliseTasks <- function(task, ...)
{
  library(doParallel)
  ncores = detectCores() - 1
  cl = makeCluster(ncores)
  registerDoParallel()
  r <- task(...)
  stopCluster(cl)
  r
}