write.gmt.EC <- function(ECIndexFilePath = "EC.20250802.des",
                         organism_id = "105023", # Nothobranchius furzeri: 105023
                         To = "Ensembl",
                         AppendDescription = FALSE,
                         LowCountThreshold = 5,
                         IgnoreLevel = c(0, 1), # Example: "EC1": lv 0, "EC1.14": lv 1, "EC1.14.11": lv 2
                         GMTFilePath = "EC.N.furzeri.gmt") {
  
  suppressPackageStartupMessages(library("stringr"))
  
  ECIndex <- read.table(ECIndexFilePath, sep = "\t", quote = "")
  
  if (file.exists("write.gmt.EC.temp")) {
    file.remove("write.gmt.EC.temp")
  }
  if (file.exists(GMTFilePath)) {
    file.remove(GMTFilePath)
  }
  for (i in 1 : nrow(ECIndex)) {
    ECNumber <- unlist(strsplit(ECIndex[i, 1], split = "EC "))[2]
    if (!(str_count(ECNumber, "\\.") %in% IgnoreLevel)) {
      system(
             paste0("curl -o write.gmt.EC.temp ",
                    "'https://rest.uniprot.org/uniprotkb/stream?download=true&fields=accession&format=tsv&query=((ec:", ECNumber,
                    ")+AND+(organism_id:", organism_id,
                    "))'")
      )
      curl.Results <- read.table("write.gmt.EC.temp", header = TRUE)
      EnsemblIDs <- unique(UniProtKBAC2EnsemblID(paste0(curl.Results[, "Entry"], collapse = ","), To = To)[, 2])
      
      if (length(EnsemblIDs) >= LowCountThreshold) {
        # may also filter out NA/""/NULL/character(0) because length(NA) == length("") == 1
        # and length(NULL) == length(character(0)) == 0
        if (AppendDescription) {
          Line <- paste0(ECIndex[i,], collapse = "\t")
        }
        else {
          Line <- ECIndex[i, 1]
        }
        Line <- paste(Line, paste0(EnsemblIDs, collapse = "\t"), sep = "\t")
        write(Line, file = GMTFilePath, append = TRUE)
      }
      
      file.remove("write.gmt.EC.temp")
    }
  }
}
