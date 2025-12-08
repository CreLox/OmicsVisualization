UniProtKBAC2EnsemblID <- function(UniProtKBAC.CSV,
                                  Wait = 5,
                                  To = "Ensembl") {
  
  suppressPackageStartupMessages(library("httr"))
  
  Response <- POST("https://rest.uniprot.org/idmapping/run",
                   body = list(ids = UniProtKBAC.CSV, from = "UniProtKB_AC-ID", to = To),
                   encode = "form",
                   accept_json())
  # Id Mapping API is not supported for mapping results with "mapped to" IDs more than 500,000
  jobId <- get.jobId.from(Response)
    
  JobOngoing <- TRUE
  while (JobOngoing) {
    SystemCommand <- paste("curl -i https://rest.uniprot.org/idmapping/status/", jobId, sep = "")
    Response <- system(SystemCommand, intern = TRUE)
    if ("{\"jobStatus\":\"FINISHED\"}" %in% Response) {
      JobOngoing <- FALSE
    }
    else {
      Sys.sleep(Wait) # in seconds
    }
  }
  
  SystemCommand <- paste("curl -s https://rest.uniprot.org/idmapping/stream/", jobId, sep = "")
  Result <- system(SystemCommand, intern = TRUE)
  return(ParseUniProtREST(Result))
}

get.jobId.from <- function(Response) {
  DecodedString <- iconv(rawToChar(Response$content), from = "UTF-8", to = "")
  return(unlist(str_split(DecodedString, pattern = "\\{\"jobId\":\"|\"\\}"))[2])
}

ParseUniProtREST <- function(Result) {
  Result1 <- gsub("\\{\"results\":\\[\\{", "", Result)
  Result2 <- gsub("\"\\}\\]\\}", "", Result1)
  Result3 <- unlist(strsplit(Result2, split = "\"\\},\\{"))
  
  Table <- matrix("", nrow = length(Result3), ncol = 2)
  colnames(Table) <- c("uniprotsptrembl", "ensembl_gene_id")
  for (i in 1 : length(Result3)) {
    StringVector <- unlist(strsplit(Result3[i], split = "\"from\":\"|\",\"to\":\"|\\."))
    Table[i,] <- c(StringVector[2], StringVector[3])
  }
  
  return(Table)
}
