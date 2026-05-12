# Corso di Informatica per la scuola di specializzazione in genetica medica III Anno 

Questo repository contiene il materiale didattico per un'esercitazione di bioinformatica NGS in ambiente UNIX/Bash.

## Obiettivi formativi

1. Comprendere i principali formati bioinformatici (FASTA, FASTQ, SAM/BAM, VCF, GFF/TSV).
2. Eseguire un controllo qualità delle reads e interpretarne i risultati.
3. Applicare una pipeline completa: FASTQ → allineamento → variant calling.
4. Confrontare e discutere output/metriche tra casi con caratteristiche diverse, inclusi casi con problemi reali di QC/preprocessing.

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
- IGV in notebook (`igv-notebook`) per visualizzare BAM/VCF direttamente in Jupyter

---


## Struttura lezioni (in aggiornamento)

Per supportare la riorganizzazione del corso in 4 lezioni, il repository include una nuova area dedicata alle sessioni pratiche:

- `lezioni/lezione1_pratica_bash/README.md`: esercitazione guidata Bash base (60–75 minuti) con 5 task a difficoltà crescente.

---

## Come usare il materiale

1. Avvia Binder.
2. Apri l'indice casi in `cases/README.md`.
3. Per gli studenti: inizia da `cases/students/README.md`, poi usa `cases/students/guida_unica.md` e il case assegnato.
4. Per il docente: usa `cases/instructor/README.md` per la mappa didattica dei case.
5. Durante il lavoro, usa `GUIDA_TOOLS.md` come riferimento su comandi, input/output e metriche.

---

## Workflow didattico

Ogni caso segue lo stesso schema generale:

1. QC iniziale con FastQC.
2. Eventuale cleaning/filtraggio reads.
3. Allineamento al riferimento con BWA.
4. Elaborazione BAM e metriche con SAMtools.
5. Variant calling con BCFtools.
6. Analisi copertura e confronto con `causative_variants.tsv`.

---

---

## Licenza

Materiale rilasciato con licenza Creative Commons (CC BY 4.0).
