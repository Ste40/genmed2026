# Caso 6

**Dataset assegnato:** `data/dataset6/sample6.fastq`

Per l'intero workflow (QC → cleaning opzionale → allineamento → variant calling → filtraggio → interpretazione), usa la guida unica:

- [Guida unica studenti](../guida_unica.md)  
  (se sei nella cartella `main/` o `reserve/`, il link relativo è corretto)

## Setup rapido per questo caso
```bash
CASE=case06
FASTQ=data/dataset6/sample6.fastq
REF=data/reference/mock_reference.fa
OUT=results/$CASE
mkdir -p $OUT/fastqc
```
