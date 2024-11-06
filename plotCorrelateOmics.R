plotCorrelateOmics <- function(DataMatrix,
                               PointSize = 1.5,
                               Alpha = 0.1,
                               UsePlotly = TRUE,
                               HighlightGeneNameRegex = regex("zgc:92275", ignore_case = TRUE),
                               HighlightColor = "#C40233",
                               HighlightSize = 2) {
  
  suppressPackageStartupMessages(library("stringr"))
  suppressPackageStartupMessages(library("tidyr"))
  suppressPackageStartupMessages(library(plotly))
  # suppressPackageStartupMessages(library(ggrepel))

  Plot <- ggplot(data = DataMatrix, aes(x = logTranscriptomicsBaseMean, y = logProteomicsBaseMean, GeneName = GeneName)) +
          geom_point(size = PointSize, alpha = Alpha, stroke = 0) +
          xlim(c(0, NA)) +
          ylim(c(0, NA)) +
          xlab("ln([mRNA] + 1)") +
          ylab("ln([protein] + 1)") +
          theme_bw() +
          theme(legend.position = "none", panel.grid.minor = element_blank(), panel.grid.major = element_blank()) +
          coord_fixed(expand = FALSE, clip = "off") # +
          # geom_text_repel(aes(label = GeneName))
          
  # Hightlight certain genes
  Plot <- Plot + geom_point(data = DataMatrix[str_detect(replace_na(unlist(DataMatrix[, "GeneName"], use.names = FALSE), ""), HighlightGeneNameRegex),], color = HighlightColor, stroke = 0, size = HighlightSize)  
  
  if (UsePlotly) {
    ggplotly(Plot)
  }
  else {
    print(Plot)
  }
}
