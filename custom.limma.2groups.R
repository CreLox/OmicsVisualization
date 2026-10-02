custom.limma.2groups <- function(LFQ.intensities.Path = "LFQ_intensities_AGPS-IN-1.xlsx",
                                 Output.Path = "LFQ_quantification_AGPS-IN-1_vs_DMSO.xlsx",
                                 Group1.name = "AGPS-IN-1",
                                 Group1.rep = 7,
                                 Group2.name = "DMSO",
                                 Group2.rep = 7,
                                 Sample.Columns = 2 : 15,
                                 ProteinID.colname = "Protein IDs",
                                 EnsemblID.colname = "Ensembl_id",
                                 GeneName.colname = "Gene name",
                                 ProteinName.colname = "Protein names") { # vibe-coded with DeepSeek V4
  
  # ---- 1. Load packages ----
  suppressPackageStartupMessages(library(readxl))
  suppressPackageStartupMessages(library(writexl))
  suppressPackageStartupMessages(library(limma))
  suppressPackageStartupMessages(library(dplyr))
  suppressPackageStartupMessages(library(tibble))
  
  # ---- 2. Read the Excel file ----
  df <- read_excel(LFQ.intensities.Path)
  
  # ---- 3. Separate annotation, expression, and IDs ----
  protein_ids <- as.character(df[[ProteinID.colname]])
  expr        <- df[, Sample.Columns]
  annotation  <- df[, c(ProteinID.colname, EnsemblID.colname, GeneName.colname, ProteinName.colname)]

  expr <- as.matrix(expr)
  storage.mode(expr) <- "numeric"
  rownames(expr) <- make.unique(protein_ids)
  
  # ---- 4. Define the experimental design ----
  group <- factor(c(rep(Group1.name, Group1.rep), rep(Group2.name, Group2.rep)),
                  levels = c(Group2.name, Group1.name))
  design <- model.matrix(~ group)
  colnames(design) <- c("Intercept", paste0(Group1.name, "_vs_", Group2.name))
  
  # ---- 5. Fit the linear model ----
  fit <- lmFit(expr, design)
  fit <- eBayes(fit)
  
  # ---- 6. Extract differential results ----
  results <- topTable(fit,
                      coef = 2,
                      number = Inf,
                      adjust.method = "BH",
                      sort.by = "P")
  
  # ---- 7. Annotation tibble, keyed on protein IDs ----
  annotation_tbl <- tibble(
    .pid  = rownames(expr),
    .ens  = annotation[[EnsemblID.colname]],
    .gene = annotation[[GeneName.colname]],
    .prot = annotation[[ProteinName.colname]]
  )
  colnames(annotation_tbl) <- c(ProteinID.colname,
                                EnsemblID.colname,
                                GeneName.colname,
                                ProteinName.colname)
  
  # ---- 8. Attach annotation (robust to name mismatch) ----
  results <- results %>%
    tibble::rownames_to_column(var = ProteinID.colname) %>%
    dplyr::left_join(annotation_tbl, by = ProteinID.colname)

  want <- c(ProteinID.colname, EnsemblID.colname,
            GeneName.colname, ProteinName.colname)
  have <- intersect(want, colnames(results))
  results <- results %>% dplyr::relocate(dplyr::all_of(have))

  # ---- 9. Rename stat columns by name, not position ----
  stat_map <- c(logFC = "log2FC", AveExpr = "AveExpr",
                t = "t", P.Value = "P.Value",
                adj.P.Val = "adj.P.Val", B = "B")
  for (old in names(stat_map)) {
    if (old %in% colnames(results)) {
      colnames(results)[colnames(results) == old] <- stat_map[[old]]
    }
  }
  
  # ---- 10. Add significance labels ----
  results <- results %>%
    mutate(
      Significance = case_when(
        adj.P.Val < 0.05 & log2FC > 0 ~ paste0("Significantly up (in the ", Group1.name, " group)"),
        adj.P.Val < 0.05 & log2FC < 0 ~ paste0("Significantly down (in the ", Group1.name, " group)"),
        TRUE                          ~ "n.s."
      )
    )
  
  # ---- 11. Save output ----
  write_xlsx(results, Output.Path)
}
