EntrezID2Ensembl <- function(EntrezID) { #vibe-coded with GPT-5.5 Instant

  get_one <- function(id) {

    Sys.sleep(0.1)

    url <- paste0("https://www.ncbi.nlm.nih.gov/gene/", id)

    html <- tryCatch(
      paste(
        readLines(url, warn = FALSE, encoding = "UTF-8"),
        collapse = "\n"
      ),
      error = function(e) return("network_error")
    )
    if (identical(html, "network_error")) {
      return("network_error")
    }

    pattern <- '<a href="http://www\\.ensembl\\.org/id/([^"]+)" data-gblink-text="Ensembl"'
    hit <- regmatches(
      html,
      regexec(pattern, html, perl = TRUE)
    )[[1]]

    if (length(hit) < 2) {
      return(NA_character_)
    }

    return(hit[2])
  }

  return(vapply(
    EntrezID,
    get_one,
    FUN.VALUE = character(1)
  ))
}
