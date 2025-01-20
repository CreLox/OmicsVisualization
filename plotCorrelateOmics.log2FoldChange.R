plotCorrelateOmics.log2FoldChange <- function(DataFrame,
                                              Alpha = 0.1,
                                              HighlightGeneNameRegex = "",
                                              HighlightAlpha = 1,
                                              HighlightColor = "#C40233",
                                              HighlightSize = 2.5) {
  
  suppressPackageStartupMessages(library("stringr"))
  suppressPackageStartupMessages(library("tidyr"))
  suppressPackageStartupMessages(library("ggplot2"))
  suppressPackageStartupMessages(library("ggh4x"))
  # suppressPackageStartupMessages(library("ggrepel"))
  
  if (ncol(DataFrame) == 4) {
    Plot <- ggplot(data = DataFrame, aes(x = Transcriptomicslog2FoldChange, y = Proteomicslog2FoldChange, GeneName = GeneName, CurrentEntrezGeneName = CurrentEntrezGeneName)) +
            geom_point(alpha = Alpha, stroke = 0) +
            # xlim(c(0, NA)) +
            # ylim(c(0, NA)) +
            xlab(bquote(log[2](FC(transcriptomics)))) +
            ylab(bquote(log[2](FC(proteomics)))) +
            theme_bw() +
            coord_axes_inside(labels_inside = TRUE, ratio = 1, expand = FALSE, clip = "off") +
            theme(legend.position = "none", panel.border = element_blank(), panel.grid.minor = element_blank()) +
            geom_vline(xintercept = 0) + geom_hline(yintercept = 0)
            # coord_fixed(expand = FALSE, clip = "off")
  }
  else {
    Plot <- ggplot(data = DataFrame, aes(x = Transcriptomicslog2FoldChange, y = Proteomicslog2FoldChange, GeneName = GeneName)) +
            geom_point(alpha = Alpha, stroke = 0) +
            # xlim(c(0, NA)) +
            # ylim(c(0, NA)) +
            xlab(bquote(log[2](FC(transcriptomics)))) +
            ylab(bquote(log[2](FC(proteomics)))) +
            theme_bw() +
            coord_axes_inside(labels_inside = TRUE, ratio = 1, expand = FALSE, clip = "off") +
            theme(legend.position = "none", panel.border = element_blank(), panel.grid.minor = element_blank()) +
            geom_vline(xintercept = 0) + geom_hline(yintercept = 0)
            # coord_fixed(expand = FALSE, clip = "off") # +
            # geom_text_repel(aes(label = GeneName))
  }
          
  # Hightlight certain genes
  if (!is.na(HighlightGeneNameRegex) & !is.null(HighlightGeneNameRegex) & (HighlightGeneNameRegex != "")) {
    if (ncol(DataFrame) == 4) {
      Plot <- Plot + geom_point(data = DataFrame[str_detect(replace_na(unlist(DataFrame[, "GeneName"], use.names = FALSE), ""), HighlightGeneNameRegex) |
                                                 str_detect(replace_na(unlist(DataFrame[, "CurrentEntrezGeneName"], use.names = FALSE), ""), HighlightGeneNameRegex),],
                                color = HighlightColor, stroke = 0, alpha = HighlightAlpha, size = HighlightSize)
    }
    else {
      Plot <- Plot + geom_point(data = DataFrame[str_detect(replace_na(unlist(DataFrame[, "GeneName"], use.names = FALSE), ""), HighlightGeneNameRegex),],
                                color = HighlightColor, stroke = 0, alpha = HighlightAlpha, size = HighlightSize)
    }
  }
  
  # cor.test(DataFrame$Proteomicslog2FoldChange, DataFrame$Transcriptomicslog2FoldChange, method = c("pearson", "kendall", "spearman"))
  return(Plot)
}
