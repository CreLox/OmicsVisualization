EntrezID2Ensembl <- function(EntrezIDs,
                             dataset = "nfurzeri_gene_ensembl") { # vibe-coded with Claude.ai Opus 5 High

  suppressPackageStartupMessages(library("biomaRt"))
  suppressPackageStartupMessages(library("retry"))
  biomartCacheClear()

  if ((length(EntrezIDs) == 0) || identical(EntrezIDs, NA) || identical(EntrezIDs, "")) {
    return("")
  }

  AllEntrezIDs <- as.character(EntrezIDs)
  QueryEntrezIDs <- unique(AllEntrezIDs[!is.na(AllEntrezIDs) & (AllEntrezIDs != "")])

  Mapping <- rep("", length(QueryEntrezIDs))
  names(Mapping) <- QueryEntrezIDs

  if (length(QueryEntrezIDs) > 0) {
    retry({
            ConsoleOutput <- capture.output({
                               BioMartTable <-
                               getBM(attributes = c("entrezgene_id", "ensembl_gene_id"),
                                     filters = "entrezgene_id", values = QueryEntrezIDs,
                                     mart = useEnsembl(biomart = "ensembl", dataset = dataset))
                             });
            if (length(ConsoleOutput) != 0) {
              stop("Error")
            }
          }, when = ".*", silent = TRUE)
    row.names(BioMartTable) <- NULL

    for (i in 1 : length(QueryEntrezIDs)) {
      EnsemblGeneIDs <- unique(BioMartTable[(as.character(BioMartTable[, "entrezgene_id"]) == QueryEntrezIDs[i]),
                                            "ensembl_gene_id"])
      Mapping[QueryEntrezIDs[i]] <- paste(EnsemblGeneIDs, collapse = "; ")
    }
  }

  # One element per input element, in the order given (duplicates kept), so the
  # result can be assigned straight into a column of the input table.
  Out <- Mapping[AllEntrezIDs]
  Out[is.na(Out)] <- ""
  names(Out) <- AllEntrezIDs

  return(Out)
}
