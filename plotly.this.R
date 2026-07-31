plotly.this <- function(GGPlot = .Last.value,
                        RemoveAxisTitles = TRUE) {
  
  suppressPackageStartupMessages(library("ggplot2"))
  suppressPackageStartupMessages(library("plotly"))
  
  if (RemoveAxisTitles) {
    ggplotly(GGPlot + xlab("") + ylab(""))
  }
  else {
    ggplotly(GGPlot)
  }
}
