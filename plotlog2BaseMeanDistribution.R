plotlog2BaseMeanDistribution <- function(ExcelDataFilePath, baseMeanColumnName = "baseMean", BinWidth = 0.1, Bins = NULL) {
  suppressPackageStartupMessages(library("ggplot2"))
  suppressPackageStartupMessages(library("readxl"))
  
  Data <- read_excel(ExcelDataFilePath)
  names(Data)[names(Data) == baseMeanColumnName] <- "baseMean"
  Plot <- ggplot(data = Data, aes(x = log2(baseMean))) +
          stat_bin(geom = "step", binwidth = BinWidth, bins = Bins, na.rm = TRUE, color = "black") +
          xlab(bquote(log[2](base~mean))) +
          ylab("Number of genes") +
          theme_bw() +
          theme(legend.position = "none", panel.grid.minor = element_blank(), panel.grid.major = element_blank()) +
          coord_cartesian(expand = FALSE, clip = "off") +
          scale_x_continuous(limits = c(0, NA))
  
  return(Plot)
}
