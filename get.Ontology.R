get.Ontology <- function(URL = "https://current.geneontology.org/ontology/go-basic.obo",
                         TempFilePath = "go-basic.obo") {
  
  suppressPackageStartupMessages(library(ontologyIndex))
  
  if (file.exists(TempFilePath)) {
    file.remove(TempFilePath)
  }
  download.file(URL, destfile = TempFilePath, quiet = TRUE)
  ontology <- get_ontology(TempFilePath, propagate_relationships = c("is_a", "part_of"))
  file.remove(TempFilePath)
  
  return(ontology)
}
