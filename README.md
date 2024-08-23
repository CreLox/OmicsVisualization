# Documentation
```GOFilter(ExcelDataFilePath, GOList, godir, GOTermColumnName = "GO_id", ReAdjustPValues = TRUE, PValueColumnName = "pvalue", AdjustedPValueColumnName = "padj")```: filter a [Flaski RNAseq pipeline](https://flaski.age.mpg.de/rnaseq/) output Excel sheet (```ExcelDataFilePath```) based on the desired GO terms in ```GOList``` [including all child terms (```is_a```, ```regulates```, etc.) defined by ```godir```].

Note: Ensembl BioMart provides a built-in functionality to filter genes by GO term annotations (all child terms are also included). This approach is better because a fresh download from Ensembl BioMart will reflect the most up-to-date GO term annotations. See ```EnsemblIDFilter()```.

```SRX2SRR(SRXSheetFilePath, SRXColumnName = "SRX")```: batch convert a column (from an Excel sheet ```SRXSheetFilePath```) of accession numbers into corresponding run numbers (printed directly onto the console alongside the sequencing technique employed).
