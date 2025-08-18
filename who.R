who <- function() {
  return(setdiff(ls(envir = parent.frame()), lsf.str(envir = parent.frame())))
}
