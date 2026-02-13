# Hands-on session nell'ambito del progetto scuola diffusa D3 4H

Questa sessione ha l'obiettivo di fornire conoscenze base per la manipolazione ed analisi di dati comunemente utilizzati in bioinformatica. 
Il corso prevede una parte teorica e attività pratiche. 
Gli obiettivi formativi dell'attività pratica sono:

1. Fornire conoscenze di base dell'ambiente UNIX e riga di comando bash.
2. Acquisire familiarità con i formati di file comunemente utilizzati in bioinformatica.
3. Fornire conoscenze di base per l'interpretazione di un report QC generato tramite il software fastqc.
4. Analizzare dei sequenziamenti: dal fastq al vcf
5. Fornire conoscenze di base nella manipolazione dei file ed interpretazione dei risultati.

L'attività pratica è erogata svolte in ambiente Jupyter tramite [Binder](https://mybinder.org).

## Requisiti

Il materiale è pensato per essere eseguito su Binder. Per avviare l'ambiente è sufficiente seguire le istruzioni:

1. Copiare l'URL di questa pagina (https://github.com/Ste40/genmed2026)
2. Incollarlo nell'apposito campo su [Binder](https://mybinder.org).
3. Cliccare "launch" ed attendere che si apra l'applicazione (potrebbero volerci diversi minuti).

**Attenzione**: la piattaforma mybinder.org garantisce almeno **1 GB** di RAM per sessione, fino a un massimo di **2 GB**; le sessioni inattive per più di 10 minuti vengono terminate.

## Contenuto

- `environment.yml` — definisce l'ambiente conda con tutti i pacchetti necessari (python, fastqc, bwa, samtools, bcftools, bedtools, R e pacchetti utili).
- `data/` — contiene un piccolo **dataset di esempio**:
  - `reference.fa`: sequenza di riferimento (500 bp) del cromosoma 1.
  - `sample.fastq`: 50 reads simulate con lunghezza 100 bp, contenenti varianti artificiali.
  - `expected_variants.vcf`: file VCF con le varianti attese per la verifica dei risultati.
- `notebooks/` — quattro notebook Jupyter che guidano attraverso le varie fasi:
  1. **01_bash_intro.ipynb** — comandi di base della shell Bash e manipolazione di file di testo.
  2. **02_fastqc_analysis.ipynb** — esecuzione di FastQC e interpretazione dei report【265213121619552†L40-L60】.
  3. **03_alignment.ipynb** — allineamento delle reads con BWA e uso di samtools per conversione e statistiche.
  4. **04_variant_calling.ipynb** — chiamata delle varianti con bcftools e confronto con il file atteso.

## Istruzioni per l'uso

1. Avviare l'ambiente Binder cliccando sul badge fornito (o utilizzando il link nel file `README`).
2. Una volta avviato, aprire i notebook nell'ordine indicato nella cartella `notebooks/`. Ogni notebook contiene spiegazioni e celle di codice da eseguire.
3. Durante l'esecuzione dei comandi assicurarsi di non superare i limiti di memoria di Binder. Il dataset fornito è progettato per consumare poche risorse.
4. Salvare regolarmente le modifiche ai notebook (`File → Save Notebook`) e scaricare eventuali file di output che si desidera conservare.

## Mini esercitazioni

Oltre agli esercizi inclusi nei notebook, si propongono alcune esercitazioni aggiuntive:

- **Ricerca e sostituzione**: usando `grep` e `sed`, trova tutte le reads che contengono una determinata sequenza (es. `GATC`) e sostituiscila con `NNNN` in un file copiato di `sample.fastq`.
- **Filtraggio per qualità**: scrivi un piccolo script Bash che scorre il file FASTQ e mantiene solo le reads con lunghezza ≥ 80 bp e qualità media ≥ 30.
- **Analisi delle coverage**: usa `bedtools genomecov` per calcolare la copertura media sul riferimento. Qual è la profondità media delle reads nel dataset?
- **Estensione**: cerca un dataset reale (es. un campione dal [NCBI SRA](https://www.ncbi.nlm.nih.gov/sra)) e ripeti il flusso completo (FastQC → allineamento → chiamata varianti) lavorando su un sottocampione (ad esempio 10.000 reads). Quali sono le differenze rispetto al dataset simulato?

## Note finali

Questo materiale è rilasciato con licenza Creative Commons (CC BY 4.0). Sentiti libero di modificarlo e riutilizzarlo citando la fonte. Per domande o suggerimenti, apri un problema (issue) nel repository o contatta il docente.
