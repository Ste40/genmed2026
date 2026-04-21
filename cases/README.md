# Casi studio end-to-end (FASTQ → varianti)

Questa cartella contiene **10 casi pratici** per l'esercitazione:

- `main/`: 5 casi principali (uno per ciascuno studente)
- `reserve/`: 5 casi di riserva (da usare in caso di anticipo, recupero o discussione avanzata)

Ogni caso è costruito per poter essere eseguito in **myBinder** (dataset piccoli, workflow leggero) e segue lo stesso schema:

1. Quality control iniziale (FastQC)
2. Pulizia/filtraggio reads (quando necessario)
3. Allineamento con BWA
4. Post-processing BAM con samtools
5. Variant calling con bcftools
6. Filtraggio e interpretazione varianti

## Convenzioni

- Riferimento: `data/reference/mock_reference.fa`
- Tabella varianti causative attese: `data/reference/causative_variants.tsv`
- Ogni caso scrive output in `results/<case_id>/...`

## Casi principali

1. [Caso 1 - pipeline baseline e verifica](main/case01_baseline.md)
2. [Caso 2 - rumore di qualità e filtri su QUAL/DP](main/case02_quality_noise.md)
3. [Caso 3 - reads corte e trimming adattivo](main/case03_short_reads.md)
4. [Caso 4 - copertura ridotta e rischio falsi negativi](main/case04_low_coverage.md)
5. [Caso 5 - qualità mista + Ns, hard filtering ragionato](main/case05_mixed_noise.md)

## Casi di riserva

6. [Caso 6 - contaminazione da adapter 3'](reserve/case06_adapter_contamination.md)
7. [Caso 7 - campione misto (due varianti ad alta AF)](reserve/case07_mixed_sample.md)
8. [Caso 8 - duplicati PCR estremi](reserve/case08_extreme_duplicates.md)
9. [Caso 9 - alta percentuale di N e code low-complexity](reserve/case09_high_N_content.md)
10. [Caso 10 - bassa copertura + errori sporadici](reserve/case10_lowcov_errors.md)
