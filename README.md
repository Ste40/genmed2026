# Hands-on session nell'ambito del progetto scuola diffusa D3 4H

Questa esercitazione introduce i concetti fondamentali della bioinformatica applicata al sequenziamento NGS, con un approccio pratico in ambiente UNIX/Bash.

## Obiettivi formativi

1. Acquisire familiarità con shell Bash e file system.
2. Comprendere i formati principali (FASTA, FASTQ, SAM/BAM, VCF, BED/GFF).
3. Eseguire e interpretare un controllo qualità (QC) su reads grezze.
4. Comprendere il flusso completo FASTQ → allineamento → varianti.
5. Leggere criticamente output, metriche e file prodotti dagli strumenti.

---

## Requisiti e avvio ambiente

Il materiale è pensato per Binder:

1. Copiare l'URL del repository: `https://github.com/Ste40/genmed2026`
2. Incollarlo su [mybinder.org](https://mybinder.org)
3. Cliccare **Launch**

> Nota: mybinder.org garantisce tipicamente almeno 1 GB RAM (fino a circa 2 GB) e chiude sessioni inattive.

---

## Struttura del repository

- `binder/environment.yml` — ambiente software dell'esercitazione.
- `data/` — dataset di esempio (reads, riferimento e file di supporto).
- `GUIDA_TOOLS.md` — guida descrittiva dei tool usati nel workflow, con input/output, metriche e file prodotti.

---

## Come usare il materiale

Le istruzioni operative dei comandi sono state riportate nei singoli casi/esercizi.
Per una visione d'insieme dei software usati e del significato dei risultati, consulta:

➡️ **[GUIDA_TOOLS.md](GUIDA_TOOLS.md)**

---

## Note finali

Materiale rilasciato con licenza Creative Commons (CC BY 4.0).
