merge.sets <- function(set.a, set.b, exception.set) {
  merged.set <- unique(c(set.a, set.b))
  
  i = 1
  while (i <= length(merged.set)) {
    if (merged.set[i] %in% exception.set) {
      merged.set <- merged.set[-i]
    }
    else {
      i = i + 1
    }
  }
  
  return(merged.set)
}
