AppendNCBIGeneDescriptionColumn <- function(ExcelDataFilePath,
                                            ExcelDataFileEnsemblIDColumnName = "ensembl_gene_id") {
  
  suppressPackageStartupMessages(library("readxl"))
  suppressPackageStartupMessages(library("writexl"))

  Table <- read_xlsx(ExcelDataFilePath)
  DescriptionColumn <- matrix(NA, nrow = nrow(Table))
  for (i in 1 : nrow(Table)) {
    DescriptionColumn[i, 1] <- EnsemblID2Entrez(Table[i, ExcelDataFileEnsemblIDColumnName], "Description")
  }
  colnames(DescriptionColumn) <- "ncbi_gene_description"
  Table <- cbind(Table, DescriptionColumn)
  write_xlsx(Table, ExcelDataFilePath)
}
