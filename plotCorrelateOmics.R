plotCorrelateOmics <- function(DataFrame,
                               Alpha = 0.1,
                               HighlightGeneNameRegex = "^rps1[^9]|^rps19$|^rps[2-5]|rps6$|^rps[7-9]|^RPS[^6]|^rpl|^RPL",
                               HighlightAlpha = 1,
                               HighlightColor = "#C40233",
                               HighlightSize = 2.5) {
  
  suppressPackageStartupMessages(library("stringr"))
  suppressPackageStartupMessages(library("tidyr"))
  suppressPackageStartupMessages(library("ggplot2"))
  # suppressPackageStartupMessages(library("ggrepel"))
  
  if (ncol(DataFrame) == 6) {
    Plot <- ggplot(data = DataFrame, aes(x = logTranscriptomicsMean, y = logProteomicsMean, GeneName = GeneName, CurrentEntrezGeneName = CurrentEntrezGeneName)) +
            geom_point(alpha = Alpha, stroke = 0) +
            xlim(c(0, NA)) +
            ylim(c(0, NA)) +
            xlab("log2([mRNA] + 1)") +
            ylab("log2([protein] + 1)") +
            theme_bw() +
            theme(legend.position = "none", panel.grid.minor = element_blank(), panel.grid.major = element_blank()) +
            coord_fixed(expand = FALSE, clip = "off")
  }
  else {
    Plot <- ggplot(data = DataFrame, aes(x = logTranscriptomicsMean, y = logProteomicsMean, GeneName = GeneName)) +
            geom_point(alpha = Alpha, stroke = 0) +
            xlim(c(0, NA)) +
            ylim(c(0, NA)) +
            xlab("log2([mRNA] + 1)") +
            ylab("log2([protein] + 1)") +
            theme_bw() +
            theme(legend.position = "none", panel.grid.minor = element_blank(), panel.grid.major = element_blank()) +
            coord_fixed(expand = FALSE, clip = "off") # +
            # geom_text_repel(aes(label = GeneName))
  }
          
  # Hightlight certain genes
  if (!is.na(HighlightGeneNameRegex) & !is.null(HighlightGeneNameRegex) & (HighlightGeneNameRegex != "")) {
    if (ncol(DataFrame) == 6) {
      Plot <- Plot + geom_point(data = DataFrame[str_detect(replace_na(unlist(DataFrame[, "GeneName"], use.names = FALSE), ""), HighlightGeneNameRegex) |
                                                 str_detect(replace_na(unlist(DataFrame[, "CurrentEntrezGeneName"], use.names = FALSE), ""), HighlightGeneNameRegex),],
                                color = HighlightColor, stroke = 0, alpha = HighlightAlpha, size = HighlightSize)
    }
    else {
      Plot <- Plot + geom_point(data = DataFrame[str_detect(replace_na(unlist(DataFrame[, "GeneName"], use.names = FALSE), ""), HighlightGeneNameRegex),],
                                color = HighlightColor, stroke = 0, alpha = HighlightAlpha, size = HighlightSize)
    }
  }
  
  # cor.test(DataFrame$logProteomicsMean, DataFrame$logTranscriptomicsMean, method = c("pearson", "kendall", "spearman"))
  return(Plot)
}
