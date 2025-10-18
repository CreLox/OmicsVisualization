custom.gmt.GSEA <- function(custom.gmt,
                            custom.des,
                            project.name = "Exit_vs_DIIpersistent",
                            LFQ.quantification.xlsx = "LFQ_quantification_Temperature2.xlsx",
                            ID.colname = "Ensembl_id",
                            log2FC.colname = "logFC Induced_exit / Diapause_II_persistent") {
  
  library(WebGestaltR)
  library(readxl)
  
  ID.log2FC <- as.data.frame(read_xlsx(LFQ.quantification.xlsx)[, c(ID.colname, log2FC.colname)])
  
  WebGestaltR(enrichMethod = "GSEA",
              organism = "others",
              hostName="https://www.webgestalt.org/",
              interestGene = ID.log2FC,
              interestGeneType = "genesymbol",
              enrichDatabaseFile = custom.gmt,
              enrichDatabaseType = "genesymbol",
              enrichDatabaseDescriptionFile = custom.des,
              saveRawGseaResult = TRUE,
              projectName = project.name)
}
