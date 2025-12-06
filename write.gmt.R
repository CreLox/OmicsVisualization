write.gmt <- function(GOList,
                      GODescriptionOnly = FALSE,
                      OutputFilePath = "custom.gmt",
                      min.Size = 1,
                      max.Size = 99999999,
                      PropagateAnnotationsToAncestor = TRUE) {
  
  suppressPackageStartupMessages(library("ribiosUtils"))
  suppressPackageStartupMessages(library("GO.db"))
  suppressPackageStartupMessages(library("ontologyIndex"))
  load("AmbiguousEnsemblID2EntrezMapping.rdata")
  GOTermList <- as.list(GOTERM)
  
  GOList <- GOList[!(names(GOList) %in% names(CensoredEnsemblIDList))]
  InvertedGOList <- invertList(GOList)
  for (i in 1 : length(InvertedGOList)) {
    InvertedGOList[[i]] <- unique(InvertedGOList[[i]])
  }
  
  if (PropagateAnnotationsToAncestor) {
    isFinal <- rep(FALSE, length(InvertedGOList))
    
    Ontology <- get.Ontology()
    ChildTermList <- setNames(vector("list", length(InvertedGOList)), names(InvertedGOList))
    for (i in 1 : length(ChildTermList)) {
      ChildTermList[[i]] <- get_descendants(Ontology, names(ChildTermList[i]), exclude_roots = FALSE)
      if (identical(ChildTermList[[i]], names(ChildTermList[i]))) {
        InvertedGOList[[i]] <- unique(InvertedGOList[[i]])
        InvertedGOList[[i]] <- InvertedGOList[[i]][order(InvertedGOList[[i]])]
        isFinal[i] <- TRUE
      }
    }
    
    while(any(!isFinal)) {
      for (i in 1 : length(isFinal)) {
        if (!isFinal[i]) {
          Child.Idx <- match(ChildTermList[[i]], names(InvertedGOList))
          if (all(isFinal[Child.Idx[!is.na(Child.Idx) & (Child.Idx != i)]])) { # all(logical(0)) == TRUE !!
            InvertedGOList[[i]] <- unique(unlist(InvertedGOList[Child.Idx[!is.na(Child.Idx)]], use.names = FALSE))
            InvertedGOList[[i]] <- InvertedGOList[[i]][order(InvertedGOList[[i]])]
            isFinal[i] <- TRUE
          }
        }
      }
    }
    
    ForgottenTerms <- merge.sets(unique(unlist(ChildTermList, use.names = F)), exception.set = names(InvertedGOList))
    if (length(ForgottenTerms) > 0) {
      ChildTermList.ForgottenTerms <- setNames(vector("list", length(ForgottenTerms)), ForgottenTerms)
      InvertedGOList.ForgottenTerms <- setNames(vector("list", length(ForgottenTerms)), ForgottenTerms)
      for (i in 1 : length(ChildTermList.ForgottenTerms)) {
        ChildTermList.ForgottenTerms[[i]] <- get_descendants(Ontology, names(ChildTermList.ForgottenTerms[i]), exclude_roots = FALSE)
      }
      RemovalIndices <- c()
      for (i in 1 : length(InvertedGOList.ForgottenTerms)) {
        Child.Idx <- match(ChildTermList.ForgottenTerms[[i]], names(InvertedGOList))
        if (length(Child.Idx[!is.na(Child.Idx)]) > 0) {
          InvertedGOList.ForgottenTerms[[i]] <- unique(unlist(InvertedGOList[Child.Idx[!is.na(Child.Idx)]], use.names = FALSE))
          InvertedGOList.ForgottenTerms[[i]] <- InvertedGOList.ForgottenTerms[[i]][order(InvertedGOList.ForgottenTerms[[i]])]
        }
        else {
          RemovalIndices <- c(RemovalIndices, i)
        }
      }
      if (length(RemovalIndices) > 0) {
        InvertedGOList <- c(InvertedGOList, InvertedGOList.ForgottenTerms[-RemovalIndices])
      }
      else {
        InvertedGOList <- c(InvertedGOList, InvertedGOList.ForgottenTerms)
      }
      InvertedGOList <- InvertedGOList[order(names(InvertedGOList))]
    }
  }
  
  # if a file of the specified path already exists, file.create() will overwrite it with an empty file.
  file.create(OutputFilePath)
  
  for (i in 1 : length(InvertedGOList)) {
    if ((length(InvertedGOList[[i]]) >= min.Size) && (length(InvertedGOList[[i]]) <= max.Size)) {
      GOID <- names(InvertedGOList[i])
      if (!is.null(GOTermList[[GOID]])) {
        Description <- Term(GOTermList[[GOID]])
      }
      else {
        Description <- "Null"
      }
      Line <- paste(GOID, Description, sep = "\t")
      
      if (!GODescriptionOnly) {
        Line <- paste(Line, paste0(InvertedGOList[[i]], collapse = "\t"), sep = "\t")
      }
      
      write(Line, file = OutputFilePath, append = TRUE)
    }
  }
  
  return(InvertedGOList)
}
