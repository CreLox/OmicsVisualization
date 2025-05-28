plotPCA <- function(OmicsExcelDataFilePath = "LFQ_intensities_Temperature.xlsx",
                    SampleColumns = 2 : 29,
                    GroupTags = c(rep("DII (arrested at 24 °C)", 6), rep("DII (persistent at 28.5 °C)", 11), rep("Development resumption", 11)),
                    PointSize = 2.5,
                    ExpandRatio = 0.1,
                    FillColorPalette = c("#FFD300", "#FFFFFF", "#0087BD"),
                    HideAxis = TRUE) {

  suppressPackageStartupMessages(library("readxl"))
  suppressPackageStartupMessages(library("ggplot2"))
  
  ProteomicsData <- as.data.frame(read_xlsx(OmicsExcelDataFilePath))
  
  PCA <- prcomp(t(ProteomicsData[, SampleColumns]), center = TRUE, scale. = TRUE)
  PC1VarPercent <- (PCA$sdev[1]) ^ 2 / sum((PCA$sdev) ^ 2)
  PC2VarPercent <- (PCA$sdev[2]) ^ 2 / sum((PCA$sdev) ^ 2)
  PCA.Results <- as.data.frame(PCA$x)

  Plot <- ggplot(data = PCA.Results, aes(x = PC1, y = PC2, fill= GroupTags)) +
          geom_point(color = "black", pch = 21, size = PointSize) +
          theme_bw() + theme(panel.grid.minor = element_blank(), panel.grid.major = element_blank(), legend.title = element_blank(), legend.position = "bottom", legend.box.spacing = unit(0, "pt"), legend.text = element_text(margin = margin(l = unit(0, "pt")))) +
          scale_fill_manual(values = FillColorPalette) +
          coord_fixed(ratio = 1, xlim = CalculateSquareHullAxisLim(PCA.Results$PC1, PCA.Results$PC2, ExpandRatio, "x"), ylim = CalculateSquareHullAxisLim(PCA.Results$PC1, PCA.Results$PC2, ExpandRatio, "y")) +
          xlab(sprintf("PC1 (%.1f%%)", PC1VarPercent * 100)) + ylab(sprintf("PC2 (%.1f%%)", PC2VarPercent * 100))
  if (HideAxis) {
    Plot <- Plot + theme(axis.text.x = element_blank(), axis.ticks.x = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank())
  }
  
  return(Plot)
}

CalculateSquareHullAxisLim <- function(X, Y, ExpandRatio, Axis) {
  Radius = max(max(X) - min(X), max(Y) - min(Y)) * (1 + ExpandRatio) / 2
  Center.x = (max(X) + min(X)) / 2
  Center.y = (max(Y) + min(Y)) / 2
  if (Axis == "x") {
    return(c(Center.x - Radius, Center.x + Radius))
  }
  if (Axis == "y") {
    return(c(Center.y - Radius, Center.y + Radius))
  }
}
