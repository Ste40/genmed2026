# Hands-on session nell'ambito del progetto scuola diffusa D3 4H

Questo repository contiene il materiale didattico per un'esercitazione di bioinformatica NGS in ambiente UNIX/Bash, organizzata come percorso a casi studio per studenti e docente.

## Obiettivi formativi

1. Comprendere i principali formati bioinformatici (FASTA, FASTQ, SAM/BAM, VCF, GFF/TSV).
2. Eseguire un controllo qualità delle reads e interpretarne i risultati.
3. Applicare una pipeline completa: FASTQ → allineamento → variant calling.
4. Confrontare e discutere output/metriche tra casi con caratteristiche diverse.

---

## Requisiti e avvio ambiente

Il materiale è pensato per Binder:

1. Copiare l'URL del repository: `https://github.com/Ste40/genmed2026`
2. Incollarlo su [mybinder.org](https://mybinder.org)
3. Cliccare **Launch**

> Nota: le sessioni Binder possono terminare dopo inattività e hanno risorse limitate.

L'ambiente software è definito in `binder/environment.yml` e include, tra gli altri:

- Python 3.10 + JupyterLab/Notebook
- FastQC, BWA, SAMtools, BCFtools, BEDTools
- cutadapt, seqtk, seqkit
- R 4.2 + tidyverse

---

## Struttura del repository

- `binder/`
  - `environment.yml` — ambiente conda dell'esercitazione.
  - `postBuild` — setup post-build per Binder.
- `data/`
  - `dataset1/` ... `dataset10/` — 10 set di reads (`sample*.fastq`) per i diversi casi.
  - `reference/` — file comuni di riferimento:
    - `mock_reference.fa`
    - `mock_annotation.gff`
    - `causative_variants.tsv`
- `cases/`
  - `students/main/` — 5 casi principali (case01–case05).
  - `students/reserve/` — 5 casi di riserva/approfondimento (case06–case10).
  - `instructor/` — guida riservata al docente.
  - `README.md` — indice rapido delle sezioni.
- `GUIDA_TOOLS.md` — spiegazione dei tool e del workflow.

---

## Come usare il materiale

1. Avvia Binder.
2. Apri l'indice casi in `cases/README.md`.
3. Per gli studenti: inizia da `cases/students/README.md` e poi dai casi `main/`.
4. Per il docente: usa `cases/instructor/README.md` per la mappa didattica dei case.
5. Durante il lavoro, usa `GUIDA_TOOLS.md` come riferimento su comandi, input/output e metriche.

---

## Workflow didattico (alto livello)

Ogni caso segue lo stesso schema generale:

1. QC iniziale con FastQC.
2. Eventuale cleaning/filtraggio reads.
3. Allineamento al riferimento con BWA.
4. Elaborazione BAM e metriche con SAMtools.
5. Variant calling con BCFtools.
6. Analisi copertura e confronto con `causative_variants.tsv`.

---

## Gestione del repository

Il repository usa `main` come branch di riferimento per il materiale didattico consolidato.

Dopo merge di PR, è consigliata la pulizia dei branch non più necessari:

```bash
# elimina branch locali già mergeati (tranne main)
git branch --merged main | grep -v '^*' | grep -v ' main$' | xargs -r git branch -d

# elimina un branch remoto specifico
git push origin --delete <nome-branch>

# aggiorna i riferimenti remoti locali
git fetch --prune
```

---

## Licenza

Materiale rilasciato con licenza Creative Commons (CC BY 4.0).
