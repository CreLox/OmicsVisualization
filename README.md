# Documentation
```GOFilter(ExcelDataFilePath, GOList, GOTermColumnName = "GO_id", ReAdjustPValues = TRUE, PValueColumnName = "pvalue", AdjustedPValueColumnName = "padj")```: filter a [DESeq2](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-014-0550-8) output Excel sheet (```ExcelDataFilePath```) based on the desired GO terms in ```GOList``` [including all child terms (```is_a```, ```regulates```, etc.) defined by ```godir```].

```SRX2SRR(SRXSheetFilePath, SRXColumnName = "SRX")```: batch convert a column (from an Excel sheet ```SRXSheetFilePath```) of accession numbers into corresponding run numbers (printed directly onto the console alongside the sequencing technique employed).
