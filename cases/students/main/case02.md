# Caso 2

**Dataset assegnato:** `data/dataset2/sample2.fastq`

Per l'intero workflow (QC → cleaning opzionale → allineamento → variant calling → filtraggio → interpretazione), usa la guida unica:

- [Guida unica studenti](../guida_unica.md)  
  (se sei nella cartella `main/` o `reserve/`, il link relativo è corretto)

## Setup rapido per questo caso
```bash
CASE=case02
FASTQ=data/dataset2/sample2.fastq
REF=data/reference/mock_reference.fa
OUT=results/$CASE
mkdir -p $OUT/fastqc
```
