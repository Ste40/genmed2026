# Casi principali per l'esercitazione

Questa cartella contiene i **6 casi principali** da assegnare alla classe.

## Casi disponibili

- [Case 01](case01.md) — `dataset1`
- [Case 02](case02.md) — `dataset2`
- [Case 03](case03.md) — `dataset3`
- [Case 04](case04.md) — `dataset4`
- [Case 05](case05.md) — `dataset5`
- [Case 06](case06.md) — `dataset6`

## Prima di iniziare

1. Apri la [guida unica studenti](../guida_unica.md).
2. Apri il case assegnato e imposta le variabili (`CASE`, `FASTQ`, `OUT`).
3. Esegui i passaggi: QC → cleaning (se necessario) → allineamento → variant calling → interpretazione.

## Output minimi attesi

Nella cartella `results/<case>/` devi produrre almeno:

- report FastQC,
- BAM ordinato + indice,
- file metriche (`flagstat.txt`, `depth.tsv`),
- VCF raw e VCF filtrati,
- eventuali file post-cleaning (`clean.fastq`, log cutadapt/seqtk).
