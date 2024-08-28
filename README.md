# Documentation

## BioMartGOFilterEnsemblID.Nfurzeri
```BioMartGOFilterEnsemblID.Nfurzeri(GO.CSV, CombineFruitFlyHomology = TRUE, CombineHumanHomology = TRUE, CombineNematodeHomology = TRUE, CombineXenopusHomology = TRUE, CombineZebrafishHomology = TRUE)```: use the [biomaRt](https://bioconductor.org/packages/release/bioc/html/biomaRt.html) package to download the Ensembl IDs of all *Nothobranchius furzeri* genes with GO term annotations in ```GO.CSV``` [including all child terms (```is_a```, ```regulates```, etc.)]. ```CombineFruitFlyHomology```/```CombineHumanHomology```/```CombineNematodeHomology```/```CombineXenopusHomology```/```CombineZebrafishHomology``` allows complementing the set using the gene homology [to fruit fly (*Drosophila melanogaster*)/human/nematode (*Caenorhabditis elegans*)/tropical clawed frog (*Xenopus tropicalis*)/zebrafish (*Danio rerio*)] information.

## EnsemblIDFilter
```EnsemblIDFilter(ExcelDataFilePath, BioMartExportFilePaths = NA, PassedEnsemblIDList = NA, ExcelDataFileEnsemblIDColumnName = "ensembl_gene_id", BioMartExportEnsemblIDColumnName, ReAdjustPValues = TRUE, PValueColumnName = "pvalue", AdjustedPValueColumnName = "padj")```: filter a [Flaski RNAseq pipeline](https://flaski.age.mpg.de/rnaseq/) output Excel sheet (```ExcelDataFilePath```) based on a list of desired Ensembl IDs

- in ```PassedEnsemblIDList``` or

- compiled from exported [Ensembl BioMart](https://www.ensembl.org/biomart/martview) TSV files whose paths are specified in ```BioMartExportFilePaths```, if ```BioMartExportFilePaths``` is not ```NA``` (note: this overrides the input variable ```PassedEnsemblIDList```).

## GOFilter
```GOFilter(ExcelDataFilePath, GOList, godir, GOTermColumnName = "GO_id", ReAdjustPValues = TRUE, PValueColumnName = "pvalue", AdjustedPValueColumnName = "padj")```: filter a Flaski RNAseq pipeline output Excel sheet (```ExcelDataFilePath```) based on the desired GO terms in ```GOList``` [including all child terms (```is_a```, ```regulates```, etc.) defined by ```godir```].

Note: Ensembl BioMart provides a built-in functionality to filter genes by GO term annotations (see the figure below; all child terms will also be included). This approach is better because a fresh download from Ensembl BioMart will reflect the most up-to-date GO term annotations. See ```BioMartGOFilterEnsemblID.Nfurzeri``` and ```EnsemblIDFilter```.

<p align="center">
<img src="assets/EnsemblBioMartGOFilter.png" width="700">
</p>

## plotlog2ReadDistribution
```plotlog2ReadDistribution(ExcelDataFilePath, DataColumns = NULL)```: plot the smoothed empirical distribution function of all normalized reads (each gene in each sample) to help determine a threshold to filter genes with valid expression and a meaningful fold-change.

## SRX2SRR
```SRX2SRR(SRXSheetFilePath, SRXColumnName = "SRX")```: batch convert a column (from an Excel sheet ```SRXSheetFilePath```) of accession numbers into corresponding run numbers (printed directly onto the console alongside the sequencing technique employed).

## Volcano.MA
```Volcano.MA(Data, PlotType, HighlightEnsemblIDs = NA, EnsemblIDColumnName = "ensembl_gene_id", log2FoldChangeColumnName = "log2FoldChange", abslog2FoldChangeThreshold = 1, abslog2FoldChangeLimit, baseMeanColumnName = "baseMean", log2baseMeanLowerLimit, log2baseMeanUpperLimit, AdjustedPValueColumnName = "padj", SignificanceThreshold = 0.01, negativelog10AdjustedPValueLimit, LineWidth = 0.25, Alpha = 1, NSAlpha = 0.1, UpColor = "#FFD300", DownColor = "#0087BD", HighlightColor = "#C40233", HighlightSize = 2.5, log2FoldChangeLabel, log2FoldChangeTickDistance = 1, log10AdjustedPValueTickDistance = 5)```: plot a volcano plot (```PlotType = "Volcano"```) or an MA plot (```PlotType = "MA"```) and highlight genes with an Ensembl ID in ```HighlightEnsemblIDs```. Points beyond limits (defined by ±```abslog2FoldChangeLimit```, ```log2baseMeanLowerLimit```, ```log2baseMeanUpperLimit```, and ```negativelog10AdjustedPValueLimit```; ignored if ```NA```) will be coerced onto the border.
