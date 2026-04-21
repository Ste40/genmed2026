# Caso 10

**Dataset assegnato:** `data/dataset10/sample10.fastq`

Per l'intero workflow (QC → cleaning opzionale → allineamento → variant calling → filtraggio → interpretazione), usa la guida unica:

- [Guida unica studenti](../guida_unica.md)  
  (se sei nella cartella `main/` o `reserve/`, il link relativo è corretto)

## Setup rapido per questo caso
```bash
CASE=case10
FASTQ=data/dataset10/sample10.fastq
REF=data/reference/mock_reference.fa
OUT=results/$CASE
mkdir -p $OUT/fastqc
```
