# Casi principali per l'esercitazione

Questa cartella contiene **tutto il necessario per l'esercitazione base** (5 casi da assegnare a 5 studenti).

## Cosa serve prima di iniziare

1. Ambiente Binder avviato dal repository.
2. Dataset disponibili in `data/dataset1` ... `data/dataset5`.
3. Riferimento e varianti attese in `data/reference/`.

## Casi disponibili

- [Case 01](case01.md) — `dataset1`
- [Case 02](case02.md) — `dataset2`
- [Case 03](case03.md) — `dataset3`
- [Case 04](case04.md) — `dataset4`
- [Case 05](case05.md) — `dataset5`

## Workflow minimo (uguale per tutti i casi)

Ogni caso include già i comandi con spiegazione. Lo schema comune è:

1. Setup variabili (`CASE`, `FASTQ`, `REF`, `OUT`).
2. QC iniziale con `fastqc`.
3. Ispezione report (`summary.txt`, `fastqc_data.txt`).
4. Eventuale cleaning guidato dal QC (`cutadapt`, `seqtk`; senza deduplicazione per sequenza identica).
5. Allineamento con `bwa mem` + preparazione BAM (`samtools`).
6. Variant calling (`bcftools mpileup` + `bcftools call`).
7. Filtraggio varianti (lenient/strict) e confronto finale.
8. Annotazione delle varianti su `mock_annotation.gff` e valutazione copertura del gene mock.

## Output attesi

Per ogni case nella cartella `results/<case>/` dovresti ottenere almeno:

- report FastQC,
- BAM ordinato + indice,
- file di metriche (`flagstat.txt`, `depth.tsv`),
- VCF raw e VCF filtrati,
- tabella di copertura su feature annotate (`mock_gene_coverage.tsv`).

Confronta poi i risultati con `data/reference/causative_variants.tsv`.
