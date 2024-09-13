samples.beeswarm <- function(GeneNameRegex, ExcelDataFilePath = "Reichwald2015Rerun_group_non_diap_vs_diap.results.xlsx", GeneNameColumnName = "gene_name", ColumnOffset = 2, Group1RepNum = 5, Group2RepNum = 5, GroupTags = c("Diapause", "Escape"), Colours = c("black", "red"), Standardized = 1, Breaks = 10, PointSize = 0.75, LineWidth = 0.5, AsteriskSignificance = TRUE, PValueColumnName = "pvalue", PValueDigit = 2) {
  
  suppressPackageStartupMessages(library("readxl"))
  suppressPackageStartupMessages(library("stringr"))
  suppressPackageStartupMessages(library("tidyr"))
  suppressPackageStartupMessages(library("ggplot2"))
  suppressPackageStartupMessages(library("ggtext"))
  suppressPackageStartupMessages(library("ggbeeswarm"))
  
  RawData <- read_excel(ExcelDataFilePath)
  # Example: GeneNameRegex <- regex(GeneNameStr, ignore_case = T)
  MatchedData <- RawData[str_detect(replace_na(unlist(RawData[, GeneNameColumnName], use.names = FALSE), ""), GeneNameRegex),]
  # Love, Huber, and Anders. "Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2." Genome Biology 15 (2014): 550.
  # The adjusted p-values are calculated according to Benjamini and Hochberg (1995) based on the total number of genes with a valid p-value.
  # If a row contains an extreme count outlier detected by Cook’s distance, the p-value will be set to NA.
  # However, only a subset of these genes are concerned and to be plotted in our application. Therefore, we will readjust the p-values:
  AdjustedP <- p.adjust(unlist(MatchedData[, PValueColumnName], use.names = FALSE), method = "fdr")
  
  FormattedData <- data.frame(matrix(ncol = 3, nrow = nrow(MatchedData) * (Group1RepNum + Group2RepNum), dimnames=list(c(), c("gene_name", "reads", "group_tag"))))
  Idx <- 0
  for (i in 1 : nrow(MatchedData)) {
    for (j in 1 : Group1RepNum) {
      Idx <- Idx + 1
      FormattedData[Idx, "reads"] <- as.numeric(MatchedData[i, j + ColumnOffset])
      if (AsteriskSignificance) {
        if (is.na(AdjustedP[i])){
          FormattedData[Idx, "gene_name"] <- sprintf("%s<br>(<i>p</i><sub>adj</sub> = NA)", toupper(MatchedData[i, GeneNameColumnName]))
        }
        else {
          if (AdjustedP[i] >= 0.05) {
            FormattedData[Idx, "gene_name"] <- sprintf("%s<br>(<i>p</i><sub>adj</sub> = %s)", toupper(MatchedData[i, GeneNameColumnName]),
              as.character(formatC(AdjustedP[i], digits = PValueDigit)))
          }
          if ((AdjustedP[i] < 0.05) & (AdjustedP[i] >= 0.01)) {
            FormattedData[Idx, "gene_name"] <- sprintf("<b>%s<br>(<span style=\"font-family:Courier\">∗</span>)</b>", toupper(MatchedData[i, GeneNameColumnName]))
          }
          if ((AdjustedP[i] < 0.01) & (AdjustedP[i] >= 0.001)) {
            FormattedData[Idx, "gene_name"] <- sprintf("<b>%s<br>(<span style=\"font-family:Courier\">∗∗</span>)</b>", toupper(MatchedData[i, GeneNameColumnName]))
          }
          if (AdjustedP[i] < 0.001) {
            FormattedData[Idx, "gene_name"] <- sprintf("<b>%s<br>(<span style=\"font-family:Courier\">∗∗∗</span>)</b>", toupper(MatchedData[i, GeneNameColumnName]))
          }
        }
      }
      else {
        FormattedData[Idx, "gene_name"] <- sprintf("%s<br>(%s)", toupper(MatchedData[i, GeneNameColumnName]),
          as.character(formatC(AdjustedP[i], format = "e", digits = PValueDigit - 1)))
      }
      FormattedData[Idx, "group_tag"] <- GroupTags[1]
    }
    
    for (j in 1 : Group2RepNum) {
      Idx <- Idx + 1
      FormattedData[Idx, "reads"] <- as.numeric(MatchedData[i, j + Group1RepNum + ColumnOffset])
      if (AsteriskSignificance) {
        if (is.na(AdjustedP[i])){
          FormattedData[Idx, "gene_name"] <- sprintf("%s<br>(<i>p</i><sub>adj</sub> = NA)", toupper(MatchedData[i, GeneNameColumnName]))
        }
        else {
          if (AdjustedP[i] >= 0.05) {
            FormattedData[Idx, "gene_name"] <- sprintf("%s<br>(<i>p</i><sub>adj</sub> = %s)", toupper(MatchedData[i, GeneNameColumnName]),
              as.character(formatC(AdjustedP[i], digits = PValueDigit)))
          }
          if ((AdjustedP[i] < 0.05) & (AdjustedP[i] >= 0.01)) {
            FormattedData[Idx, "gene_name"] <- sprintf("<b>%s<br>(<span style=\"font-family:Courier\">∗</span>)</b>", toupper(MatchedData[i, GeneNameColumnName]))
          }
          if ((AdjustedP[i] < 0.01) & (AdjustedP[i] >= 0.001)) {
            FormattedData[Idx, "gene_name"] <- sprintf("<b>%s<br>(<span style=\"font-family:Courier\">∗∗</span>)</b>", toupper(MatchedData[i, GeneNameColumnName]))
          }
          if (AdjustedP[i] < 0.001) {
            FormattedData[Idx, "gene_name"] <- sprintf("<b>%s<br>(<span style=\"font-family:Courier\">∗∗∗</span>)</b>", toupper(MatchedData[i, GeneNameColumnName]))
          }
        }
      }
      else {
        FormattedData[Idx, "gene_name"] <- sprintf("%s<br>(%s)", toupper(MatchedData[i, GeneNameColumnName]),
          as.character(formatC(AdjustedP[i], format = "e", digits = PValueDigit - 1)))
      }
      FormattedData[Idx, "group_tag"] <- GroupTags[2]
    }
    
    # If all data are to be standardized based on group #1's mean:
    if (Standardized == 1) {
      StandardMean = mean(FormattedData[(Idx - Group1RepNum - Group2RepNum + 1) : (Idx - Group2RepNum), "reads"])
      FormattedData[(Idx - Group1RepNum - Group2RepNum + 1) : Idx, "reads"] <- FormattedData[(Idx - Group1RepNum - Group2RepNum + 1) : Idx, "reads"] / StandardMean
    }
    # If all data are to be standardized based on group #2's mean:
    if (Standardized == 2) {
      StandardMean = mean(FormattedData[(Idx - Group2RepNum + 1) : Idx, "reads"])
      FormattedData[(Idx - Group1RepNum - Group2RepNum + 1) : Idx, "reads"] <- FormattedData[(Idx - Group1RepNum - Group2RepNum + 1) : Idx, "reads"] / StandardMean
    }
  }
  
  Plot <- ggplot(FormattedData, aes(y = gene_name, x = reads, color = group_tag)) +
    # accurate "method" options: swarm (default), compactswarm
    # "corral" (to control runaway points) options: "gutter" (collects runaway points along the boundary between groups),
    # "wrap" (implement periodic boundaries), "random" (places runaway points randomly in the region)
    geom_beeswarm(method = "swarm", corral = "wrap", dodge.width = PointSize, size = PointSize) +
    scale_color_manual(values = Colours) +
    theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    axis.ticks = element_line(linewidth = LineWidth, colour = "black"),
    axis.text.y = element_markdown(colour = "black"), axis.text.x = element_text(colour = "black"),
    panel.border = element_blank(),
    axis.title.y = element_blank(), axis.title.x = element_text(colour = "black"),
    legend.title = element_blank(), legend.position = "bottom", legend.background = element_rect(fill = NA)) +
    expand_limits(x = c(0, max(pretty(c(FormattedData$reads, max(FormattedData$reads) * 1.01))))) +
    scale_x_continuous(n.breaks = Breaks)
  XTicks <- ggplot_build(Plot)$layout$panel_params[[1]]$x$breaks
  Plot <- Plot + annotate("segment", x = 0, y = 0, yend = 0, xend = max(XTicks, na.rm = T), colour = "black", linewidth = LineWidth * 2)
  # The line above creates a fake axis but also causes an issue wherein the axis.title.x and the legend may not be centered to this fake axis...
  if (Standardized != 0) {
    Plot <- Plot + xlab("Standardized (per gene) transcription level") + 
      geom_vline(xintercept = 1, linetype = "dashed", linewidth = LineWidth * 0.5, colour = Colours[Standardized])
  }
  else {
    Plot <- Plot + xlab("Transcription level (normalized by the median of ratios)")
  }
  Plot <- Plot + theme(legend.box.spacing = unit(0, "pt"), legend.text = element_text(colour = "black", margin = margin(l = unit(0, "pt"))))
  
  savePNG(Plot)
  return(Plot)
}

savePNG <- function(Plot, FileName = sprintf("%s.png",format(Sys.time(), "%Y%m%d_%H-%M-%S")), Unit = "in", Resolution = 1200, Width = 4.5, HeightIntercept = 1.2, HeigthCoefficient = 0.5) {
  
  suppressPackageStartupMessages(library("ragg"))
  if (Sys.info()[['sysname']] == "Darwin") {
    suppressPackageStartupMessages(library("systemfonts"))
    register_font("",
      plain = "/System/Library/Fonts/Supplemental/Arial.ttf",
      bold = "/System/Library/Fonts/Supplemental/Arial Bold.ttf",
      italic = "/System/Library/Fonts/Supplemental/Arial Italic.ttf",
      bolditalic = "/System/Library/Fonts/Supplemental/Arial Bold Italic.ttf")
  }
  
  agg_png(filename = FileName, unit = Unit, res = Resolution,
          width = Width, height = HeightIntercept + HeigthCoefficient * length(unique(Plot$data$gene_name)))
  print(Plot)
  
  clear_registry()
  dev.off()
}
