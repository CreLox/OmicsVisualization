write.gmt <- function(GOList,
                      OutputFilePath = "custom.gmt") {
  
  suppressPackageStartupMessages(library("ribiosUtils"))
  suppressPackageStartupMessages(library("GO.db"))
  GOTermList <- as.list(GOTERM)
  InvertedGOList <- invertList(GOList)
  
  # if a file of this path already exists, this overwrites it with an empty file
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
    
    Elements <- InvertedGOList[[i]]
    for (j in 1 : length(Elements)) {
      Line <- paste(Line, Elements[j], sep = "\t")
    }
    
    write(Line, file = OutputFilePath, append = TRUE)
  }
}
