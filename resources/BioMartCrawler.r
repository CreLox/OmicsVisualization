BioMartCrawler <- function() {
  # Modified from codes by ChatGPT
  suppressPackageStartupMessages(library("httr"))
  suppressPackageStartupMessages(library("stringr"))
  
  URL <- "https://www.ensembl.org/biomart/martview"
  Start <- ",'default____Ensembl Genes "
  End <- "]\\}"
  Split <- "':{'datasetmenu_3':["
  Pattern <- paste0(Start, "(.*?)", End)
  
  PageSource <- content(GET(URL), "text", encoding = "UTF-8")
  Match <- str_match(PageSource, Pattern)
  SplitMatch <- unlist(strsplit(Match[2], split = Split, fixed = TRUE))
  
  SplitMatch[2] <- gsub("\\\\\\'", "___", SplitMatch[2])
  Matches <- gregexpr("\\['([^']+)',\\s*'([^']+)'\\]", SplitMatch[2], perl = TRUE)
  Parsed <- regmatches(SplitMatch[2], Matches)[[1]]
  DataList <- lapply(Parsed, function(x) {
    subx <- gsub("^\\['|']$", "", x)
    strsplit(subx, "',\\s*'")[[1]]
  })
  DataFrame <- do.call(rbind, DataList)
  DataFrame <- gsub("___", "\\'", DataFrame)
  
  write.table(DataFrame, file = paste0("EnsemblGenes", SplitMatch[1], ".txt"), quote = FALSE, sep = '\t', col.names = FALSE, row.names = FALSE)
}
