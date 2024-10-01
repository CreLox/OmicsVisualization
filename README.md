# Documentation
## AppendNCBIGeneDescriptionColumn
```AppendNCBIGeneDescriptionColumn(ExcelDataFilePath, ExcelDataFileEnsemblIDColumnName = "ensembl_gene_id")```

Appends a column of NCBI gene descriptions to an Excel sheet with a column (named ```ExcelDataFileEnsemblIDColumnName```) containing Ensembl IDs. Depends on ```EnsemblID2Entrez```.

## BioMartGOFilter.GOList.Nfurzeri
```BioMartGOFilter.GOList.Nfurzeri(GO.CSV, CombineFruitFlyHomology = TRUE, CombineHumanHomology = TRUE, CombineMouseHomology = TRUE, CombineNematodeHomology = TRUE, CombineXenopusHomology = TRUE, CombineYeastHomology = TRUE, CombineZebrafishHomology = TRUE)```

Use the [biomaRt](https://bioconductor.org/packages/release/bioc/html/biomaRt.html) package to get all *Nothobranchius furzeri* genes with GO term annotations in ```GO.CSV``` [including all child terms (```is_a```, ```regulates```, etc.)]. ```CombineFruitFlyHomology```/```CombineHumanHomology```/```CombineMouseHomology```/```CombineNematodeHomology```/```CombineXenopusHomology```/```CombineYeastHomology```/```CombineZebrafishHomology``` allows complementation using the gene homology [to fruit fly (*Drosophila melanogaster*)/human/mouse (*Mus musculus*)/nematode (*Caenorhabditis elegans*)/frog (*Xenopus tropicalis*)/yeast (*Saccharomyces cerevisiae*)/zebrafish (*Danio rerio*)] information.

## EnsemblID2Entrez
```EnsemblID2Entrez(EnsemblID, Output = "Accession")```

Converts a single Ensembl ID to its corresponding NCBI Entrez accession(s)/ID(s)/description(s) (```Output = c("Accession", "ID", "Description")```) using the [rentrez](https://docs.ropensci.org/rentrez/) package. If the mapping exists, the output will be a string array; otherwise, the output will be ```""```. This works better than using ```biomaRt``` because the mapping is more complete. And unlike using ```org.*.eg.db```, this works for all species.

Note: the default genome assembly of *Nothobranchius furzeri* on Ensembl is still ```Nfu_20140520``` while NCBI opts for ```UI_Nfuz_MZM_1.0``` as the default. This may cause differences in annotations.

## EnsemblIDFilter
```EnsemblIDFilter(ExcelDataFilePath, BioMartExportFilePaths = NA, PassedEnsemblIDArray = NA, ExcelDataFileEnsemblIDColumnName = "ensembl_gene_id", BioMartExportEnsemblIDColumnName, ReAdjustPValues = TRUE, PValueColumnName = "pvalue", AdjustedPValueColumnName = "padj")```

Filters a [Flaski RNAseq pipeline](https://flaski.age.mpg.de/rnaseq/) output Excel sheet (```ExcelDataFilePath```) based on an array of desired Ensembl IDs

- in ```PassedEnsemblIDArray``` or

- compiled from exported [Ensembl BioMart](https://www.ensembl.org/biomart/martview) TSV files whose paths are specified in ```BioMartExportFilePaths```, if ```BioMartExportFilePaths``` is not ```NA``` (note: this overrides the input variable ```PassedEnsemblIDArray```).

## FindUniqueGenes.EnsemblID
```FindUniqueGenes.EnsemblID(TargetSpecies, CheckHomologySpecies = c("drerio", "kmarmoratus", "olatipes", "ssalar"))```

Identifies genes of the ```TargetSpecies``` (returns an array of their Ensembl IDs) without a homolog in ```CheckHomologySpecies```.

## GOFilter
```GOFilter(ExcelDataFilePath, GOList, godir, GOTermColumnName = "GO_id", ReAdjustPValues = TRUE, PValueColumnName = "pvalue", AdjustedPValueColumnName = "padj")```

Filters a Flaski RNAseq pipeline output Excel sheet (```ExcelDataFilePath```) based on the desired GO terms in ```GOList``` [including all child terms (```is_a```, ```regulates```, etc.) defined by ```godir```].

Note: Ensembl BioMart provides a built-in functionality to filter genes by GO term annotations (see the figure below; all child terms will also be included). This approach is better because a fresh download from Ensembl BioMart will reflect the most up-to-date GO term annotations. See ```BioMartGOFilter.Nfurzeri``` and ```EnsemblIDFilter```.

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

Batch converts a column (from an Excel sheet ```SRXSheetFilePath```) of accession numbers into corresponding run numbers (printed directly onto the console alongside the sequencing technique employed).

## volcano.ma
```volcano.ma(Data, PlotType = "ma", HighlightEnsemblIDs = NA, EnsemblIDColumnName = "ensembl_gene_id", log2FoldChangeColumnName = "log2FoldChange", abslog2FoldChangeThreshold = 1, abslog2FoldChangeLimit, baseMeanColumnName = "baseMean", log2baseMeanLowerLimit, log2baseMeanUpperLimit, AdjustedPValueColumnName = "padj", SignificanceThreshold = 0.01, negativelog10AdjustedPValueLimit, LineWidth = 0.25, Alpha = 1, NSAlpha = 0.1, UpColor = "#FFD300", DownColor = "#0087BD", HighlightColor = "#C40233", HighlightSize = 2.5, log2FoldChangeLabel, log2FoldChangeTickDistance = 1, log10AdjustedPValueTickDistance = 5)```

Plots a volcano plot (```PlotType = "volcano"```) or an MA plot (```PlotType = "ma"```) and highlight genes with an Ensembl ID in ```HighlightEnsemblIDs```. Points beyond limits (defined by ±```abslog2FoldChangeLimit```, ```log2baseMeanLowerLimit```, ```log2baseMeanUpperLimit```, and ```negativelog10AdjustedPValueLimit```; ignored if ```NA```) will be coerced onto the border.
