plotCorrelateOmics <- function(DataFrame,
                               Alpha = 0.1,
                               HighlightGeneNameRegex = "^rps[1-5]|rps6$|^rps[7-9]|^rpl|^RPS[^6]|^RPL",
                               HighlightAlpha = 1,
                               HighlightColor = "#C40233",
                               HighlightSize = 2.5) {
  
  suppressPackageStartupMessages(library("stringr"))
  suppressPackageStartupMessages(library("tidyr"))
  suppressPackageStartupMessages(library("ggplot2"))
  # suppressPackageStartupMessages(library(ggrepel))

  Plot <- ggplot(data = DataFrame, aes(x = logTranscriptomicsMean, y = logProteomicsMean, GeneName = GeneName)) +
          geom_point(alpha = Alpha, stroke = 0) +
          xlim(c(0, NA)) +
          ylim(c(0, NA)) +
          xlab("ln([mRNA] + 1)") +
          ylab("ln([protein] + 1)") +
          theme_bw() +
          theme(legend.position = "none", panel.grid.minor = element_blank(), panel.grid.major = element_blank()) +
          coord_fixed(expand = FALSE, clip = "off") # +
          # geom_text_repel(aes(label = GeneName))
          
  # Hightlight certain genes
  if (!is.na(HighlightGeneNameRegex) & !is.null(HighlightGeneNameRegex) & (HighlightGeneNameRegex != "")) {
    Plot <- Plot + geom_point(data = DataFrame[str_detect(replace_na(unlist(DataFrame[, "GeneName"], use.names = FALSE), ""), HighlightGeneNameRegex),],
                              color = HighlightColor, stroke = 0, alpha = HighlightAlpha, size = HighlightSize)
  }
  
  # cor.test(DataFrame$logProteomicsMean, DataFrame$logTranscriptomicsMean, method = c("pearson", "kendall", "spearman"))
  return(Plot)
}
