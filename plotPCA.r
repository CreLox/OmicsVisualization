plotPCA <- function(OmicsExcelDataFilePath = "LFQ_intensities_Temperature.xlsx",
                    SampleColumns = 2 : 29,
                    GroupTags = c(rep("DII (arrested at 24 °C)", 6), rep("DII (persistent at 28.5 °C)", 11), rep("Development resumption", 11)),
                    PointSize = 2,
                    FillColorPalette = c("#FFD300", "#FFFFFF", "#0087BD")) {

  suppressPackageStartupMessages(library("readxl"))
  suppressPackageStartupMessages(library("ggplot2"))
  
  ProteomicsData <- as.data.frame(read_xlsx(OmicsExcelDataFilePath))
  
  PCA <- prcomp(t(ProteomicsData[, SampleColumns]), center = TRUE, scale. = TRUE)
  PC1VarPercent <- (PCA$sdev[1]) ^ 2 / sum((PCA$sdev) ^ 2)
  PC2VarPercent <- (PCA$sdev[2]) ^ 2 / sum((PCA$sdev) ^ 2)

  Plot <- ggplot(data = as.data.frame(PCA$x), aes(x = PC1, y = PC2, fill= GroupTags)) +
          geom_point(color = "black", pch = 21, size = PointSize) +
          theme_bw() + theme(panel.grid.minor = element_blank(), panel.grid.major = element_blank(), legend.title = element_blank(), legend.position = "bottom", axis.text.x = element_blank(), axis.ticks.x = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank(), legend.box.spacing = unit(0, "pt"), legend.text = element_text(margin = margin(l = unit(0, "pt")))) +
          scale_fill_manual(values = FillColorPalette) +
          xlab(sprintf("PC1 (%.1f%%)", PC1VarPercent * 100)) + ylab(sprintf("PC2 (%.1f%%)", PC2VarPercent * 100))
  
  return(Plot)
}
