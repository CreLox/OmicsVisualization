SRX2SRR <- function(SRXSheetFilePath, SRXColumnName = "SRX") {
  library("readxl")
  library("rvest")
  library("pracma")
  
  SRXSheetContent <- read_excel(SRXSheetFilePath)
  SRXVector <- SRXSheetContent[[SRXColumnName]]
  fprintf("   Run#   \tFormat\n-----------\t------\n")
  for (i in 1 : length(SRXVector)) {
    if (is.na(SRXVector[i])) {
    	  fprintf("\n")
    	}
    	else {
      url <- paste('https://www.ncbi.nlm.nih.gov/sra/', SRXVector[i], sep = "")
      SRXPage <- read_html(url)
      
      RemoveAfterRunNumber <- sub("</a></td>\n<td align=\"right\">.*", "", SRXPage)
      SRRNumber <- sub(".*\">SRR", "", RemoveAfterRunNumber)
      fprintf(paste("SRR", SRRNumber, "\t", sep = ""))
      
      RemoveBeforeFormat <- sub(".*Layout: <span>", "", SRXPage)
      Format <- sub("</span>\n</div>\n.*", "", RemoveBeforeFormat)
      fprintf(paste(Format, "\n", sep = ""))
    }
  }
}
