# Documentation
## AppendNCBIGeneDescriptionColumn
```AppendNCBIGeneDescriptionColumn(ExcelDataFilePath, ExcelDataFileEnsemblIDColumnName = "ensembl_gene_id")```

Appends a column of NCBI gene descriptions to an Excel sheet with a column (named ```ExcelDataFileEnsemblIDColumnName```) containing Ensembl IDs. Depends on ```EnsemblID2Entrez```.

## BioMartGOFilter.*Nfurzeri*
```BioMartGOFilter.Nfurzeri(GO.CSV, CombineFruitFlyHomology = TRUE, CombineHumanHomology = TRUE, CombineMouseHomology = TRUE, CombineNematodeHomology = TRUE, CombineZebrafishHomology = TRUE)```

Use the [biomaRt](https://bioconductor.org/packages/release/bioc/html/biomaRt.html) package to get all *Nothobranchius furzeri* genes with GO term annotations in ```GO.CSV``` [including all child terms (```is_a```, ```regulates```, etc.)]. ```CombineFruitFlyHomology```/```CombineHumanHomology```/```CombineMouseHomology```/```CombineNematodeHomology```/```CombineZebrafishHomology``` allows complementation using the gene homology [to fly (*Drosophila melanogaster*)/human/mouse (*Mus musculus*)/nematode (*Caenorhabditis elegans*)/zebrafish (*Danio rerio*)] information. Note that this only works for Ensembl 113 (released on October 18th, 2024) or later.

The output is a list in which the name of each element is the Ensembl ID of a *N. furzeri* gene and the content of each element is the GO term annotations of that gene (supplemented with homology information). 

## CorrelateOmics
```CorrelateOmics(ProteomicsDataFilePath = "LFQ_intensities.xlsx", UniProtIDColumnName = "Protein IDs", GeneNameColumnName = "Gene name", ProteomicsColumnsToCalculateMean, TranscriptomicsDataFilePath, TranscriptomicsColumnsToCalculateMean, dataset, RefreshGeneNames = TRUE)```

```plotCorrelateOmics(DataFrame, Alpha = 0.1, HighlightGeneNameRegex, HighlightAlpha = 1, HighlightColor = "#C40233", HighlightSize = 2.5)```

```CorrelateOmics``` links proteomics data from ```ProteomicsDataFilePath``` and transcriptomics data from ```TranscriptomicsDataFilePath``` of each gene from the species referred by the BioMart ```dataset```. Only proteins/genes with a one-to-one mapping will be included. The result is a data frame with 5 columns: "logTranscriptomicsMean", "logTranscriptomicsStdev", "logProteomicsMean", "logProteomicsStdev", and (NCBI) "GeneName". The row names of the data frame are the Ensembl IDs. If ```RefreshGeneNames``` is set as ```TRUE```, ```EnsemblID2Entrez``` (see below) will be deployed to re-download gene names from the NCBI, overwriting the original ones from the ```GeneNameColumnName``` column in ```ProteomicsDataFilePath```.

```plotCorrelateOmics``` can plot the resulting data frame. To highlight certain genes, specify them by their NCBI gene names using the ```HighlightGeneNameRegex```. The returned [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html) can be viewed interactively by [plotly](https://plotly.com/r/)::```ggplotly```.

## EnsemblID2Entrez
```EnsemblID2Entrez(EnsemblID, Output = c("Accession", "ID", "Description", "Name"))```

Converts a single Ensembl ID to its corresponding NCBI Entrez accession(s)/ID(s)/description(s)/name(s) using the [rentrez](https://docs.ropensci.org/rentrez/) package. If the mapping exists, the output will be a string; otherwise, the output will be ```""```. This works better than using ```biomaRt``` because the mapping is more complete. And unlike using ```org.*.eg.db```, this works for all species.

Note: the default genome assembly of *Nothobranchius furzeri* on Ensembl is still ```Nfu_20140520``` while the NCBI opts for the new ```UI_Nfuz_MZM_1.0``` as the default (the ```UI_Nfuz_MZM_1.0``` assembly has less unknown base pairs and more annotated genes owing to the long-read sequencing method, but the ```Nfu_20140520``` assembly has a slightly higher BUSCO score). This may cause differences in annotations.

## EnsemblIDFilter
```EnsemblIDFilter(ExcelDataFilePath, BioMartExportFilePaths = NA, PassedEnsemblIDVector = NA, ExcelDataFileEnsemblIDColumnName = "ensembl_gene_id", BioMartExportEnsemblIDColumnName, ReAdjustPValues = TRUE, PValueColumnName = "pvalue", AdjustedPValueColumnName = "padj")```

Filters a [Flaski RNAseq pipeline](https://flaski.age.mpg.de/rnaseq/) output Excel sheet (```ExcelDataFilePath```) based on an vector of desired Ensembl IDs

- in ```PassedEnsemblIDVector``` or

- compiled from exported [Ensembl BioMart](https://www.ensembl.org/biomart/martview) TSV files whose paths are specified in ```BioMartExportFilePaths```, if ```BioMartExportFilePaths``` is not ```NA``` (note: this overrides the input variable ```PassedEnsemblIDVector```).

## FindUniqueGenes.EnsemblID
```FindUniqueGenes.EnsemblID(TargetSpecies, CheckHomologySpecies = c("drerio", "kmarmoratus"))```

Identifies genes of the ```TargetSpecies``` (returns a vector of their Ensembl IDs) without a homolog in ```CheckHomologySpecies```.

## GOFilter
```GOFilter(ExcelDataFilePath, GOVector, godir, GOTermColumnName = "GO_id", ReAdjustPValues = TRUE, PValueColumnName = "pvalue", AdjustedPValueColumnName = "padj")```

Filters a Flaski RNAseq pipeline output Excel sheet (```ExcelDataFilePath```) based on the desired GO terms in ```GOVector``` [including all child terms (```is_a```, ```regulates```, etc.) defined by ```godir```].

Note: Ensembl BioMart provides a built-in functionality to filter genes by GO term annotations (see the figure below; all child terms will also be included), which is better because a fresh download from Ensembl BioMart will reflect the most up-to-date GO term annotations. See ```BioMartGOFilter.Nfurzeri``` and ```EnsemblIDFilter```.

<p align="center">
<img src="assets/EnsemblBioMartGOFilter.png" width="700">
</p>

## plotlog2ReadDistribution
```plotlog2ReadDistribution(ExcelDataFilePath, DataColumns)```

Plots the smoothed empirical distribution function of all normalized reads (each gene in each sample; compiled from columns whose IDs/names are in ```DataColumns```) to help determine a threshold to filter genes with valid expression and a meaningful fold-change. This step is helpful when picking genes for further functional studies but dispensable if only bioinformatic analyses (like a [gene set enrichment analysis](https://www.pnas.org/doi/10.1073/pnas.0506580102)) are to be done.

## samples.beeswarm
```samples.beeswarm(GeneNameRegex, ExcelDataFilePath, GeneNameColumnName = "gene_name", ColumnOffset = 2, Group1RepNum, Group2RepNum, GroupTags, Colours = c("black", "red"), Standardized = 1, Breaks = 10, PointSize = 0.75, LineWidth = 0.5, AsteriskSignificance = TRUE, PValueColumnName = "pvalue", PValueDigit = 2)```

Plots a beeswarm plot of sample reads for gene(s) whose name(s) match the ```GeneNameRegex```. If ```Standardized == 1``` (or ```Standardized ==  2```), the sample reads of each gene will be standardized by the mean of sample reads of group 1 (or 2) of each gene; otherwise, no standardization will be performed. The plot is automatically saved as a time-tagged ```.png``` file in the working directory.

## SRX2SRR
```SRX2SRR(SRXSheetFilePath, SRXColumnName = "SRX")```

Converts a column (from an Excel sheet ```SRXSheetFilePath```) of experiment numbers into corresponding run numbers (printed directly onto the console alongside the sequencing format employed). Note that this critical sequencing format info is not available in ```SRA_Accessions.tab``` (which allows batch searching using the corresponding SRP/PRJNA accession number directly) or ```SRA_Run_Members.tab``` (which allows batch searching using the corresponding SRP accession number) on [the FTP site](https://ftp.ncbi.nlm.nih.gov/sra/reports/Metadata/).

**Recommended alternative:** [the SRA Run Selector tool](https://www.ncbi.nlm.nih.gov/Traces/study/) provided by the NCBI (→ [tutorial](https://github.com/NCBI-Hackathons/ncbi-cloud-tutorials/blob/master/SRA%20tutorials/tutorial_SRA_run_selector.md)). We can get an overview of all the project's associated datasets by searching for the corresponding SRP/PRJNA/GSE accession number (see the figure attached below as an example for an overview of all datasets in [Hussein et al., *Developmental Cell*, 2020](https://www.sciencedirect.com/science/article/pii/S1534580719310676)).

<p align="center">
<img src="assets/SRARunSelector_Example.png" width="700">
</p>

## volcano.ma
```volcano.ma(Data, PlotType = "ma", HighlightEnsemblIDs = NA, GeneNameColumnName = "gene_name", EnsemblIDColumnName = "ensembl_gene_id", log2FoldChangeColumnName = "log2FoldChange", abslog2FoldChangeThreshold = 1, abslog2FoldChangeLimit, baseMeanColumnName = "baseMean", log2baseMeanLowerLimit, log2baseMeanUpperLimit, AdjustedPValueColumnName = "padj", SignificanceThreshold = 0.01, negativelog10AdjustedPValueLimit, LineWidth = 0.25, Alpha = 1, NSAlpha = 0.1, UpColor = "#FFD300", DownColor = "#0087BD", HighlightColor = "#C40233", HighlightSize = 2.5, log2FoldChangeLabel, log2FoldChangeTickDistance = 1, log10AdjustedPValueTickDistance = 5)```

Plots a volcano plot (```PlotType = "volcano"```) or an MA plot (```PlotType = "ma"```) and highlight genes with an Ensembl ID in ```HighlightEnsemblIDs```. Points beyond limits (defined by ±```abslog2FoldChangeLimit```, ```log2baseMeanLowerLimit```, ```log2baseMeanUpperLimit```, and ```negativelog10AdjustedPValueLimit```; ignored if ```NA```) will be coerced onto the border.

Note while using ```ggplotly``` to plot the graph: the axis titles should be adjusted to avoid an error [for the volcano plot, use ```Plot <- Plot + xlab("log2(fold change)") + ylab("-log10(p_adj)"); ggplotly(Plot)```; for the MA plot, use ```Plot <- Plot + xlab("log2(base mean)") + ylab("log2(fold change)"); ggplotly(Plot)```].
