# Documentation

## BioMartGOFilter.Nfurzeri
```BioMartGOFilter.EnsemblID.Nfurzeri(GO.CSV, CombineFruitFlyHomology = TRUE, CombineHumanHomology = TRUE, CombineNematodeHomology = TRUE, CombineXenopusHomology = TRUE, CombineZebrafishHomology = TRUE)```

```BioMartGOFilter.GOList.Nfurzeri(GO.CSV, CombineFruitFlyHomology = TRUE, CombineHumanHomology = TRUE, CombineNematodeHomology = TRUE, CombineXenopusHomology = TRUE, CombineZebrafishHomology = TRUE)```

Use the [biomaRt](https://bioconductor.org/packages/release/bioc/html/biomaRt.html) package to get all *Nothobranchius furzeri* genes with GO term annotations in ```GO.CSV``` [including all child terms (```is_a```, ```regulates```, etc.)]. ```CombineFruitFlyHomology```/```CombineHumanHomology```/```CombineNematodeHomology```/```CombineXenopusHomology```/```CombineZebrafishHomology``` allows complementation using the gene homology [to fruit fly (*Drosophila melanogaster*)/human/nematode (*Caenorhabditis elegans*)/tropical clawed frog (*Xenopus tropicalis*)/zebrafish (*Danio rerio*)] information.

## EnsemblID2EntrezAccession
```EnsemblID2EntrezAccession <- function(EnsemblID)```

Converts a single Ensembl ID to its corresponding NCBI Entrez accession using the [rentrez](https://docs.ropensci.org/rentrez/) package. This works better than using biomaRt because the database is more complete. And unlike using org.XX.eg.db, it works for all species.

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

## SRX2SRR
```SRX2SRR(SRXSheetFilePath, SRXColumnName = "SRX")```

Batch converts a column (from an Excel sheet ```SRXSheetFilePath```) of accession numbers into corresponding run numbers (printed directly onto the console alongside the sequencing technique employed).

## Volcano.MA
```Volcano.MA(Data, PlotType, HighlightEnsemblIDs = NA, EnsemblIDColumnName = "ensembl_gene_id", log2FoldChangeColumnName = "log2FoldChange", abslog2FoldChangeThreshold = 1, abslog2FoldChangeLimit, baseMeanColumnName = "baseMean", log2baseMeanLowerLimit, log2baseMeanUpperLimit, AdjustedPValueColumnName = "padj", SignificanceThreshold = 0.01, negativelog10AdjustedPValueLimit, LineWidth = 0.25, Alpha = 1, NSAlpha = 0.1, UpColor = "#FFD300", DownColor = "#0087BD", HighlightColor = "#C40233", HighlightSize = 2.5, log2FoldChangeLabel, log2FoldChangeTickDistance = 1, log10AdjustedPValueTickDistance = 5)```

Plots a volcano plot (```PlotType = "Volcano"```) or an MA plot (```PlotType = "MA"```) and highlight genes with an Ensembl ID in ```HighlightEnsemblIDs```. Points beyond limits (defined by ±```abslog2FoldChangeLimit```, ```log2baseMeanLowerLimit```, ```log2baseMeanUpperLimit```, and ```negativelog10AdjustedPValueLimit```; ignored if ```NA```) will be coerced onto the border.
