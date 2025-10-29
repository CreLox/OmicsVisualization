transcript.level.zebrafish.dev.stage <- function(EnsemblID,
                                                 DataFilePath = "zf-stages.GRCz11.e111.all-counts.csv",
                                                 Stages = c("1-cell", "2-cell", "128-cell", "1k-cell", "Dome", "50%-epiboly", "Shield", "75%-epiboly", "1-4-somites", "14-19-somites", "20-25-somites", "Prim-5", "Prim-15", "Prim-25", "Long-pec", "Protruding-mouth", "Day-4", "Day-5"),
                                                 EnsemblIDColumnName = "GeneID",
                                                 StartColumn = 99,
                                                 SampleNumber = 5,
                                                 PointSize = 0.75,
                                                 LineWidth = 0.25,
                                                 ErrorBarWidth = 0.2,
                                                 DataPointColor = "#888888",
                                                 YAxisTitle = "DESeq2-normalized reads") {
  
  suppressPackageStartupMessages(library("ggplot2"))
  suppressPackageStartupMessages(library("ggbeeswarm"))
  suppressPackageStartupMessages(library("tidyverse"))
  
  AllData <- read.csv(DataFilePath)
  NormalizedCountDataForThisGene <- as.numeric(t(AllData[AllData[, EnsemblIDColumnName] == EnsemblID, StartColumn : ncol(AllData)]))
  GroupTag <- rep(Stages, each = SampleNumber)
  ggplotData <- data.frame(GroupTag, NormalizedCountDataForThisGene)
  
  YTicks <- pretty(c(0, max(NormalizedCountDataForThisGene)))
  Plot <- ggplot(ggplotData, aes(y = NormalizedCountDataForThisGene, x = fct_inorder(GroupTag))) +
          geom_beeswarm(method = "compactswarm", size = PointSize, color = DataPointColor) +
          stat_summary(geom = "errorbar", fun.data = mean_se, width = ErrorBarWidth, linewidth = LineWidth) +
          stat_summary(geom = "crossbar", fun = mean, width = ErrorBarWidth * 1.75, fatten = LineWidth * 4) +
          theme_bw() + theme(axis.ticks = element_line(linewidth = LineWidth), axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1), axis.title.x = element_text(face = "bold"), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.border = element_blank()) +
          scale_y_continuous(breaks = YTicks, limits = range(YTicks)) +
          xlab(EnsemblID) + ylab(YAxisTitle)
  Plot <- Plot + annotate("segment", x = 0, y = 0, xend = 0, yend = max(YTicks), linewidth = LineWidth * 2)
  
  print(Plot)
  return(Plot)
}
