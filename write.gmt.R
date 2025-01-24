write.gmt <- function(GOList,
                      OutputFilePath = "custom.gmt") {
  
  suppressPackageStartupMessages(library("ribiosUtils"))
  InvertedGOList <- invertList(GOList)
  
  # if a file of this path already exists, this overwrites it with an empty file
  file.create(OutputFilePath)
  
  for (i in 1 : length(InvertedGOList)) {
    Line <- names(InvertedGOList[i])
    Elements <- InvertedGOList[[i]]
    for (j in 1 : length(Elements)) {
      Line <- paste(Line, Elements[j], sep = "\t")
    }
    write(Line, file = OutputFilePath, append = TRUE)
  }
}
