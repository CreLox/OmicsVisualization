UniProtGOFilter <- function(GO,
                            organism_id = "105023", # Nothobranchius furzeri: 105023
                            To = "Ensembl") {
  
  if (file.exists("write.gmt.EC.temp")) {
    file.remove("write.gmt.EC.temp")
  }
  
  system(
         paste0("curl -o write.gmt.EC.temp ",
                "'https://rest.uniprot.org/uniprotkb/stream?download=true&fields=accession&format=tsv&query=((", GO,
                ")+AND+(organism_id:", organism_id,
                "))'")
  )
  curl.Results <- read.table("write.gmt.EC.temp", header = TRUE)
  file.remove("write.gmt.EC.temp")
  
  return(unique(UniProtKBAC2EnsemblID(paste0(curl.Results[, "Entry"], collapse = ","), To = To)[, 2]))
}
