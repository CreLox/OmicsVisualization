write.gmt <- function(GOList,
                      GODescriptionOnly = FALSE,
                      OutputFilePath = "custom.gmt") {
  
  suppressPackageStartupMessages(library("ribiosUtils"))
  suppressPackageStartupMessages(library("GO.db"))
  GOTermList <- as.list(GOTERM)
  InvertedGOList <- invertList(GOList)
  
  # if a file of the specified path already exists, file.create() will overwrite it with an empty file.
  file.create(OutputFilePath)
  
  for (i in 1 : length(InvertedGOList)) {
    GOID <- names(InvertedGOList[i])
    if (!is.null(GOTermList[[GOID]])) {
      Description <- Term(GOTermList[[GOID]])
    }
    else {
      Description <- "Null"
    }
    Line <- paste(GOID, Description, sep = "\t")
    
    if (!GODescriptionOnly) {
      Elements <- InvertedGOList[[i]]
      for (j in 1 : length(Elements)) {
        Line <- paste(Line, Elements[j], sep = "\t")
      }
    }
    
    write(Line, file = OutputFilePath, append = TRUE)
  }
}
