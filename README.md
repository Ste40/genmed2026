# Hands-on session nell'ambito del progetto scuola diffusa D3 4H

Questa sessione fornisce competenze di base per la manipolazione e l'analisi di dati bioinformatici tramite workflow completo **FASTQ → BAM → VCF**.

## Obiettivi formativi

1. Usare comandi base UNIX/Bash in modo autonomo.
2. Riconoscere e manipolare i formati bioinformatici principali (FASTQ, FASTA, BAM, VCF).
3. Interpretare un report di quality control con FastQC.
4. Eseguire un'analisi end-to-end: allineamento, post-processing e variant calling.
5. Applicare filtri e ragionare criticamente sui risultati finali.

L'attività pratica è erogata in ambiente Jupyter tramite [myBinder](https://mybinder.org).

## Avvio su Binder

1. Copia l'URL del repository: `https://github.com/Ste40/genmed2026`
2. Incollalo su [myBinder](https://mybinder.org)
3. Premi **Launch** e attendi l'avvio

> **Nota risorse myBinder**: in genere 1–2 GB RAM/sessione e timeout di inattività ~10 minuti. I dataset inclusi sono volutamente piccoli.

## Struttura del repository

- `binder/environment.yml` — ambiente Conda con tool principali (`fastqc`, `bwa`, `samtools`, `bcftools`, `seqtk`, `seqkit`, `cutadapt`, ecc.).
- `data/reference/` — riferimento genomico e annotazioni:
  - `mock_reference.fa`
  - `mock_annotation.gff`
  - `causative_variants.tsv` (varianti attese per tutti i casi)
- `data/dataset1...dataset10/` — 10 FASTQ toy per esercitazioni.
- `notebooks/` — notebook introduttivi su Bash, QC, allineamento e variant calling.
- `cases/` — nuovi casi studio pronti all'uso:
  - `cases/main/` (5 casi principali)
  - `cases/reserve/` (5 casi di riserva)

## Nuovo pacchetto casi studio (5 + 5)

Per assegnare un caso a ciascuno dei 5 partecipanti e mantenere 5 alternative:

- Casi principali: `cases/main/case01_...md` → `case05_...md`
- Casi riserva: `cases/reserve/case06_...md` → `case10_...md`

Ogni caso contiene:

1. scenario del problema bioinformatico
2. workflow completo con comandi shell
3. strategia di pulizia/filtraggio dati
4. controlli di qualità e confronto risultati
5. traccia per discussione finale

Indice completo: `cases/README.md`.

## Suggerimento didattico

Assegna un caso per studente (1–5) e usa i casi 6–10 per:

- recupero in caso di imprevisti
- approfondimento per studenti più veloci
- discussione comparativa su trade-off di filtro (sensibilità vs specificità)

## Licenza

Materiale rilasciato con licenza Creative Commons (CC BY 4.0).
