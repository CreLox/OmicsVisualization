protein.level.zebrafish.dev.stage <- function(EnsemblID,
                                              DataFilePath = "media-2.xlsx",
                                              Stages = c("1-cell", "2-cell", "16-cell", "128-cell", "1k-cell", "Oblong", "Dome", "50%-epiboly", "Shield", "75%-epiboly", "Bud", "6-somite", "14-somite", "21-somite", "26-somite", "Prim-5"),
                                              EnsemblIDColumnName = "Gene ID",
                                              Skip = 3,
                                              StartColumn = 9,
                                              SampleNumber = 3,
                                              PointSize = 0.75,
                                              LineWidth = 0.25,
                                              ErrorBarWidth = 0.2,
                                              DataPointColor = "#888888",
                                              YAxisTitle = "MaxQuant-normalized levels") {
  
  suppressPackageStartupMessages(library("readxl"))
  suppressPackageStartupMessages(library("ggplot2"))
  suppressPackageStartupMessages(library("ggbeeswarm"))
  suppressPackageStartupMessages(library("tidyverse"))
  
  AllData <- as.data.frame(read_xlsx(DataFilePath, skip = Skip, na = "NA"))
  AllData[is.na(AllData[, EnsemblIDColumnName]), EnsemblIDColumnName] <- ""
  if (sum(AllData[, EnsemblIDColumnName] == EnsemblID) > 1) {
    stop(paste0("Multiple protein entries with the same Ensembl gene ID (likely due to alternative splicing) in ", DataFilePath))
  }
  
  NormalizedCountDataForThisGene <- as.numeric(t(AllData[AllData[, EnsemblIDColumnName] == EnsemblID, StartColumn : ncol(AllData)]))
  GroupTag <- rep(Stages, each = SampleNumber)
  ggplotData <- data.frame(GroupTag, NormalizedCountDataForThisGene)
  
  YTicks <- pretty(c(0, max(NormalizedCountDataForThisGene)))
  Plot <- ggplot(ggplotData, aes(y = NormalizedCountDataForThisGene, x = fct_inorder(GroupTag))) +
          geom_beeswarm(method = "compactswarm", size = PointSize, color = DataPointColor) +
          stat_summary(geom = "errorbar", fun.data = mean_se, width = ErrorBarWidth, linewidth = LineWidth) +
          stat_summary(geom = "crossbar", fun = mean, width = ErrorBarWidth * 1.75, linewidth = LineWidth) +
          theme_bw() + theme(axis.ticks = element_line(linewidth = LineWidth), axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1), axis.title.x = element_text(face = "bold"), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.border = element_blank()) +
          scale_y_continuous(breaks = YTicks, limits = range(YTicks)) +
          xlab(EnsemblID) + ylab(YAxisTitle)
  Plot <- Plot + annotate("segment", x = 0, y = 0, xend = 0, yend = max(YTicks), linewidth = LineWidth * 2)
  
  print(Plot)
  return(Plot)
}
