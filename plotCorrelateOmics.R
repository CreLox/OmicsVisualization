plotCorrelateOmics <- function(DataMatrix,
                               PointSize = 1.5,
                               Alpha = 0.1,
                               UsePlotly = TRUE) {
  
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
  
  if (UsePlotly) {
    ggplotly(Plot)
  }
  else {
    print(Plot)
  }
}
