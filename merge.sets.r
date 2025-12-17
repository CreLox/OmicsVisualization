merge.sets <- function(set.a, set.b = c(), boundary.set = NULL, exception.set = c()) {
  merged.set <- unique(c(set.a, set.b))
  
  if (length(boundary.set) > 0) {
    merged.set <- merged.set[merged.set %in% boundary.set]
  }
  
  merged.set <- merged.set[!(merged.set %in% exception.set)]
  
  return(merged.set)
}
