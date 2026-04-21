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

La procedura dettagliata è stata centralizzata qui:

- [Guida unica studenti](../guida_unica.md)

Nei file `caseXX.md` trovi solo assegnazione dataset + setup rapido del caso.

## Output attesi

Per ogni case nella cartella `results/<case>/` dovresti ottenere almeno:

- report FastQC,
- BAM ordinato + indice,
- file di metriche (`flagstat.txt`, `depth.tsv`),
- VCF raw e VCF filtrati,
- tabella di copertura su feature annotate (`mock_gene_coverage.tsv`).

Confronta poi i risultati con `data/reference/causative_variants.tsv`.
