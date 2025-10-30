plotlnReadDistribution <- function(ExcelDataFilePath, DataColumns) {
  suppressPackageStartupMessages(library("readxl"))
  suppressPackageStartupMessages(library("ggplot2"))
  
  Data <- read_excel(ExcelDataFilePath)
  X <- NULL
  for (i in DataColumns) {
    X <- c(X, unlist(Data[, i]))
  }
  X <- as.data.frame(X[!is.na(X)])
  rownames(X) <- NULL
  colnames(X) <- "NormalizedRead"
  
  # BinWidth = 0.1; Bins = NULL
  Plot <- ggplot(data = X, aes(x = log(NormalizedRead + 1))) +
          # stat_bin(geom = "step", binwidth = BinWidth, bins = Bins, na.rm = TRUE, color = "black") +
          geom_density(color = "black") +
          xlab(bquote(ln(normalized~read + 1))) +
          ylab("Empirical distribution") +
          theme_bw() +
          theme(legend.position = "none", panel.grid.minor = element_blank(), panel.grid.major = element_blank()) +
          coord_cartesian(expand = FALSE, clip = "off") +
          scale_x_continuous(limits = c(0, NA))
  
  return(Plot)
}
