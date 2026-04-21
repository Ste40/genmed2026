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

- `environment.yml` — definisce l'ambiente conda con tutti i pacchetti necessari (python, fastqc, bwa, samtools, bcftools, bedtools, R e pacchetti utili).
- `data/` — contiene un piccolo **dataset di esempio**:
  - `reference.fa`: sequenza di riferimento (500 bp) del cromosoma 1.
  - `sample.fastq`: 50 reads simulate con lunghezza 100 bp, contenenti varianti artificiali.
  - `expected_variants.vcf`: file VCF con le varianti attese per la verifica dei risultati.
- `notebooks/` — quattro notebook Jupyter che guidano attraverso le varie fasi:
  1. **01_bash_intro.ipynb** — comandi di base della shell Bash e manipolazione di file di testo.
  2. **02_fastqc_analysis.ipynb** — esecuzione di FastQC e interpretazione dei report.
  3. **03_alignment.ipynb** — allineamento delle reads con BWA e uso di samtools per conversione e statistiche.
  4. **04_variant_calling.ipynb** — chiamata delle varianti con bcftools e confronto con il file atteso.

## Struttura del repository

- `binder/environment.yml` — ambiente software dell'esercitazione.
- `data/` — dataset di esempio (reads, riferimento e file di supporto).
- `GUIDA_TOOLS.md` — guida descrittiva dei tool usati nel workflow, con input/output, metriche e file prodotti.


## Gestione del repository

Per mantenere il repository ordinato, il flusso di lavoro prevede un **unico branch principale: `main`**.

- usare `main` come riferimento ufficiale del materiale didattico;
- evitare branch permanenti aggiuntivi;
- usare eventualmente branch temporanei solo per modifiche locali e poi riallinearli su `main`.

### Pulizia dei branch (locale + remoto)

Dopo il merge di una PR, eliminare i branch non più necessari:

```bash
# elimina branch locali già mergeati (tranne main)
git branch --merged main | grep -v '^*' | grep -v ' main$' | xargs -r git branch -d

# elimina un branch remoto specifico
git push origin --delete <nome-branch>

# aggiorna i riferimenti remoti locali
git fetch --prune
```

Su GitHub conviene anche attivare **Settings → General → Pull Requests → Automatically delete head branches**.

Indice casi: `cases/README.md`.

## Come usare il materiale

Le istruzioni operative dei comandi sono state riportate nei singoli casi/esercizi.
Per una visione d'insieme dei software usati e del significato dei risultati, consulta:

➡️ **[GUIDA_TOOLS.md](GUIDA_TOOLS.md)**

---

## Note finali

Materiale rilasciato con licenza Creative Commons (CC BY 4.0).
