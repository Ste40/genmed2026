# Hands-on session nell'ambito del progetto scuola diffusa D3 4H

Questa sessione fornisce competenze di base per la manipolazione e l'analisi di dati bioinformatici tramite workflow completo **FASTQ → BAM → VCF**.

## Obiettivi formativi

1. Usare comandi base UNIX/Bash in modo autonomo.
2. Riconoscere e manipolare i formati bioinformatici principali (FASTQ, FASTA, BAM, VCF).
3. Interpretare un report di quality control con FastQC.
4. Eseguire un'analisi end-to-end: allineamento, post-processing e variant calling.
5. Applicare filtri e ragionare criticamente sui risultati finali.

## Avvio su Binder

1. Copia l'URL del repository: `https://github.com/Ste40/genmed2026`
2. Incollalo su [myBinder](https://mybinder.org)
3. Premi **Launch** e attendi l'avvio

> **Nota risorse myBinder**: in genere 1–2 GB RAM/sessione e timeout di inattività ~10 minuti. I dataset inclusi sono volutamente piccoli.

## Struttura del repository

- `binder/environment.yml` — ambiente Conda con tutti i tool necessari all'esercitazione.
- `data/reference/` — riferimento genomico, annotazione e tabella varianti attese.
- `data/dataset1...dataset10/` — FASTQ toy per esercitazioni.
- `notebooks/` — notebook introduttivi su Bash, QC, allineamento e variant calling.
- `cases/`:
  - `cases/students/` → casi didattici **anonimizzati** per studenti
  - `cases/instructor/` → guida riservata docente con dettagli sui singoli casi

## Assegnazione consigliata (5 + 5)

- Assegna i casi `01..05` ai 5 partecipanti (uno per studente).
- Mantieni `06..10` come casi di riserva/approfondimento.

I casi studenti sono progettati per:
- spiegare software e razionale di ogni comando,
- far prendere decisioni motivate su pulizia reads e filtri varianti,
- permettere ispezione dei report FastQC sia da HTML sia da terminale (`unzip -p ...`).

Indice casi: `cases/README.md`.

## Licenza

Materiale rilasciato con licenza Creative Commons (CC BY 4.0).
