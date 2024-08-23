# Documentation

## EnsemblIDFilter
```EnsemblIDFilter(ExcelDataFilePath, BioMartExportFilePaths, ExcelDataFileEnsemblIDColumnName = "ensembl_gene_id", BioMartExportEnsemblIDColumnName, ReAdjustPValues = TRUE, PValueColumnName = "pvalue", AdjustedPValueColumnName = "padj")``` filter a [Flaski RNAseq pipeline](https://flaski.age.mpg.de/rnaseq/) output Excel sheet (```ExcelDataFilePath```) based on a list of desired Ensembl IDs compiled from exported [Ensembl BioMart](https://www.ensembl.org/biomart/martview) TSV files (whose paths are specified in ```BioMartExportFilePaths```). In each of the TSV files, the desired Ensembl IDs are taken from the column named ```BioMartExportEnsemblIDColumnName```.

## GOFilter
```GOFilter(ExcelDataFilePath, GOList, godir, GOTermColumnName = "GO_id", ReAdjustPValues = TRUE, PValueColumnName = "pvalue", AdjustedPValueColumnName = "padj")```: filter a Flaski RNAseq pipeline output Excel sheet (```ExcelDataFilePath```) based on the desired GO terms in ```GOList``` [including all child terms (```is_a```, ```regulates```, etc.) defined by ```godir```].

Note: Ensembl BioMart provides a built-in functionality to filter genes by GO term annotations (see the figure below; all child terms will also be included). This approach is better because a fresh download from Ensembl BioMart will reflect the most up-to-date GO term annotations. See ```EnsemblIDFilter```.

<p align="center">
<img src="assets/EnsemblBioMartGOFilter.png" width="700">
</p>

## SRX2SRR
```SRX2SRR(SRXSheetFilePath, SRXColumnName = "SRX")```: batch convert a column (from an Excel sheet ```SRXSheetFilePath```) of accession numbers into corresponding run numbers (printed directly onto the console alongside the sequencing technique employed).
