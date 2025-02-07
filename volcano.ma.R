volcano.ma <- function(Data, PlotType = "ma", HighlightIDs = NA, GeneNameColumnName = "gene_name", IDColumnName = "ensembl_gene_id", log2FoldChangeColumnName = "log2FoldChange", Invertlog2FoldChange = FALSE, abslog2FoldChangeThreshold = 1, abslog2FoldChangeLimit = 3, baseMeanColumnName = "baseMean", log2baseMeanLowerLimit = 0, log2baseMeanUpperLimit = NA, AdjustedPValueColumnName = "padj", SignificanceThreshold = 0.01, negativelog10AdjustedPValueLimit = 15, LineWidth = 0.25, Alpha = 1, NSAlpha = 0.1, UpColor = "#FFD300", DownColor = "#0087BD", HighlightColor = "#C40233", HighlightSize = 2.5, log2FoldChangeLabel = bquote(log[2](Escape/Diapause)), log2FoldChangeTickDistance = 1, log10AdjustedPValueTickDistance = 5) {
  suppressPackageStartupMessages(library("ggplot2"))
  
  # Initialization
  Data <- as.data.frame(Data)
  names(Data)[names(Data) == log2FoldChangeColumnName] <- "log2FoldChange"
  names(Data)[names(Data) == GeneNameColumnName] <- "gene_name"
  Data[, "log2FoldChange"] <- as.numeric(Data[, "log2FoldChange"])
  if (Invertlog2FoldChange) {
    Data[, "log2FoldChange"] <- -Data[, "log2FoldChange"]
  }
  Data[, AdjustedPValueColumnName] <- as.numeric(Data[, AdjustedPValueColumnName])
  
  # Categorize each gene based on its log2FoldChange and AdjustedPValue and assemble the data frame
  Category <- rep("ns", nrow(Data))
  for (i in 1 : nrow(Data)) {
    if ((Data[i, "log2FoldChange"] >= abslog2FoldChangeThreshold) &
        (!is.na(Data[i, AdjustedPValueColumnName])) &
        (Data[i, AdjustedPValueColumnName] < SignificanceThreshold)) {
      Category[i] <- "up"
    }
    if ((Data[i, "log2FoldChange"] <= -abslog2FoldChangeThreshold) &
        (!is.na(Data[i, AdjustedPValueColumnName])) &
        (Data[i, AdjustedPValueColumnName] < SignificanceThreshold)) {
      Category[i] <- "down"
    }
  }
  negativelog10AdjustedPValue <- -log10(Data[, AdjustedPValueColumnName])
  Data <- cbind(Data, Category, negativelog10AdjustedPValue)
  if (PlotType == "ma") {
    log2baseMean <- log2(as.numeric(Data[, baseMeanColumnName]))
    Data <- cbind(Data, log2baseMean)
  }
  
  # Preprocessing
  Data <- Data[!is.na(Data[, AdjustedPValueColumnName]),]
  if (!is.na(negativelog10AdjustedPValueLimit)) {
    for (i in 1 : nrow(Data)) {
      if (Data[i, "negativelog10AdjustedPValue"] > negativelog10AdjustedPValueLimit) {
        Data[i, "negativelog10AdjustedPValue"] <- negativelog10AdjustedPValueLimit
      }
    }
  }
  if (!is.na(abslog2FoldChangeLimit)) {
    for (i in 1 : nrow(Data)) {
      if (Data[i, "log2FoldChange"] > abslog2FoldChangeLimit) {
        Data[i, "log2FoldChange"] <- abslog2FoldChangeLimit
      }
      if (Data[i, "log2FoldChange"] < -abslog2FoldChangeLimit) {
        Data[i, "log2FoldChange"] <- -abslog2FoldChangeLimit
      }
    }
  }
  if (PlotType == "ma") {
    if (!is.na(log2baseMeanUpperLimit)) {
      for (i in 1 : nrow(Data)) {
        if (Data[i, "log2baseMean"] > log2baseMeanUpperLimit) {
          Data[i, "log2baseMean"] <- log2baseMeanUpperLimit
        }
      }
    }
    if (!is.na(log2baseMeanLowerLimit)) {
      for (i in 1 : nrow(Data)) {
        if (Data[i, "log2baseMean"] < log2baseMeanLowerLimit) {
          Data[i, "log2baseMean"] <- log2baseMeanLowerLimit
        }
      }
    }
  }
  
  # Volcano plot
  if (PlotType == "volcano") {
    Plot <- ggplot(data = Data, aes(x = log2FoldChange, y = negativelog10AdjustedPValue, GeneName = gene_name)) +
            geom_point(aes(color = Category, alpha = Category), stroke = 0) +
            scale_color_manual(values = c("up" = UpColor, "down" = DownColor, "ns" = "black")) + 
            scale_alpha_manual(values = c("up" = Alpha, "down" = Alpha, "ns" = NSAlpha)) +
            geom_hline(yintercept = -log10(SignificanceThreshold), linetype = "dashed", linewidth = LineWidth) +
            geom_vline(xintercept = c(-abslog2FoldChangeThreshold, abslog2FoldChangeThreshold), linetype = "dashed", linewidth = LineWidth) +
            xlab(log2FoldChangeLabel) +
            ylab(bquote(-log[10](italic(p)[adj]))) +
            theme_bw() +
            theme(legend.position = "none", panel.grid.minor = element_blank(), panel.grid.major = element_blank()) +
            coord_cartesian(expand = FALSE, clip = "off") +
            scale_x_continuous(breaks = c(seq(from = -abslog2FoldChangeLimit, by = log2FoldChangeTickDistance, to = abslog2FoldChangeLimit), -abslog2FoldChangeThreshold, abslog2FoldChangeThreshold), limits = c(-abslog2FoldChangeLimit, abslog2FoldChangeLimit)) +
            scale_y_continuous(breaks = c(seq(from = 0, by = log10AdjustedPValueTickDistance, to = negativelog10AdjustedPValueLimit), -log10(SignificanceThreshold)), limits = c(0, negativelog10AdjustedPValueLimit))
  }
  
  # MA plot
  if (PlotType == "ma") {
    Plot <- ggplot(data = Data, aes(x = log2baseMean, y = log2FoldChange, GeneName = gene_name)) +
            geom_point(aes(color = Category, alpha = Category), stroke = 0) +
            scale_color_manual(values = c("up" = UpColor, "down" = DownColor, "ns" = "black")) + 
            scale_alpha_manual(values = c("up" = Alpha, "down" = Alpha, "ns" = NSAlpha)) +
            geom_hline(yintercept = c(-abslog2FoldChangeThreshold, abslog2FoldChangeThreshold), linetype = "dashed", linewidth = LineWidth) +
            ylab(log2FoldChangeLabel) +
            xlab(bquote(log[2](base~mean))) +
            theme_bw() +
            theme(legend.position = "none", panel.grid.minor = element_blank(), panel.grid.major = element_blank()) +
            coord_cartesian(expand = FALSE, clip = "off") +
            scale_x_continuous(limits = c(log2baseMeanLowerLimit, log2baseMeanUpperLimit)) +
            scale_y_continuous(breaks = c(seq(from = -abslog2FoldChangeLimit, by = log2FoldChangeTickDistance, to = abslog2FoldChangeLimit), -abslog2FoldChangeThreshold, abslog2FoldChangeThreshold), limits = c(-abslog2FoldChangeLimit, abslog2FoldChangeLimit))
  }
  
  # Hightlight certain genes
  Plot <- Plot + geom_point(data = Data[Data[, IDColumnName] %in% HighlightIDs,], color = HighlightColor, stroke = 0, size = HighlightSize)  
  
  return(Plot)
}
