write.gmt.KEGG <- function(Species3Letters = "nfu",
                           BioMartDataset = "nfurzeri_gene_ensembl",
                           SpeciesSuffix = " - Nothobranchius furzeri",
                           DescriptionFilePath = "DescriptionOnly.tsv",
                           GMTFilePath = "custom.gmt") {
  
  suppressPackageStartupMessages(library("KEGGREST"))
  suppressPackageStartupMessages(library("biomaRt"))
  suppressPackageStartupMessages(library("retry"))
  biomartCacheClear()
  # if a file of the specified path already exists, file.create() will overwrite it with an empty file.
  file.create(DescriptionFilePath)
  file.create(GMTFilePath)
  
  Pathways <- unique(keggLink("pathway", Species3Letters))
  for (i in 1 : length(Pathways)) {
    Info <- keggGet(Pathways[i])[[1]]
    PathwayID <- unlist(strsplit(Pathways[i], split = "path:"))[2]
    Description <- unlist(strsplit(Info$NAME, split = SpeciesSuffix))[1]
    if (!is.null(Info$GENE)) {
      Genes <- Info$GENE[seq(1, length(Info$GENE) - 1, by = 2)]
      retry({
              ConsoleOutput <- capture.output({
                                 EnsemblIDs <-
                                 getBM(attributes = "ensembl_gene_id",
                                       filters = "entrezgene_id", values = paste(Genes, collapse = ","),
                                       mart = useEnsembl(biomart = "ensembl", dataset = BioMartDataset))
                               });
              if (length(ConsoleOutput) != 0) {
                stop("Error")
              }
            }, when = ".*", silent = TRUE)
      Line <- paste(PathwayID, Description, sep = "\t")
      write(Line, file = DescriptionFilePath, append = TRUE)
      Line <- paste(Line, paste(unlist(EnsemblIDs), collapse = "\t"), sep = "\t")
      write(Line, file = GMTFilePath, append = TRUE)
    }
  }
}
