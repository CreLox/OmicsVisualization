merge.two.lists <- function(x, y) {
  merged.list <- list()
  
  if (length(x) == 0) {
    return(y)
  }
  if (length(y) == 0) {
    return(x)
  }
  
  for (i in 1 : length(x)) {
    if (names(x[i]) %in% names(y)) {
      idx <- which(names(y) == names(x[i]))
      this <- list(unique(c(x[[i]], y[[idx]])))
      names(this) <- names(x[i])
      merged.list <- c(merged.list, this)
    }
    else {
      merged.list <- c(merged.list, x[i])
    }
  }
  for (i in 1 : length(y)) {
    if (!(names(y[i]) %in% names(x))) {
      merged.list <- c(merged.list, y[i])
    }
  }
  
  return(merged.list)
}
