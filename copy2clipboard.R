copy2clipboard <- function(content,
                           transpose = FALSE,
                           row.names = FALSE,
                           col.names = FALSE) {
  
  suppressPackageStartupMessages(library("clipr"))
  clear_clip()
  
  if (transpose) {
    if (is.vector(content)) {
      write_clip(as.character(content), breaks = "\t", row.names = row.names, col.names = col.names)
    }
    else {
      write_clip(as.matrix(t(content)), row.names = row.names, col.names = col.names)
    }
  }
  else {
    if (is.vector(content)) {
      write_clip(as.character(content), row.names = row.names, col.names = col.names)
    }
    else {
      write_clip(as.matrix(content), row.names = row.names, col.names = col.names)
    }
  }
  
}
