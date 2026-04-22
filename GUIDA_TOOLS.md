# Guida ai tool usati nell'esercitazione

In questa pagina ho raccolto, in modo organico, i software che usiamo durante l'esercitazione.
L'idea è avere un riferimento unico: cosa fa ogni strumento, quando lo uso, che file gli do in ingresso, cosa mi restituisce e quali metriche vale la pena leggere con attenzione.

---

## Il flusso completo, in poche righe

Il percorso è quello classico di una piccola analisi NGS:

1. parto dalle reads (`FASTQ`) e dal riferimento (`FASTA`);
2. controllo la qualità con **FastQC**;
3. allineo le reads al riferimento con **BWA**;
4. converto/ordino/indicizzo gli allineamenti con **SAMtools**;
5. chiamo le varianti con **BCFtools**;
6. valuto la copertura con **BEDTools**;
7. riassumo e visualizzo i risultati con **Bash** e, quando serve, **R/tidyverse**.

Se una fase è debole (ad esempio qualità iniziale bassa), il problema si trascina anche sulle fasi successive.

---

## 1) Ambiente: Binder + conda

Per evitare installazioni locali, l'esercitazione gira su Binder. L'ambiente è definito in `binder/environment.yml`.

### Software principali inclusi

- Python 3.10
- FastQC
- BWA
- SAMtools
- BCFtools
- BEDTools
- R (con tidyverse)
- JupyterLab / Notebook

### Cosa produce questa parte

Binder in sé non produce output bioinformatici: mette a disposizione un ambiente pronto. Gli output veri e propri (HTML, BAM, VCF, TSV, ecc.) li generano i tool durante l'analisi.

---

## 2) Bash e utility UNIX

Bash è il collante dell'intera esercitazione. Lo uso per concatenare comandi, filtrare testo, creare file intermedi e costruire piccoli workflow ripetibili.

### Comandi ricorrenti

- esplorazione file: `pwd`, `ls`, `head`, `tail`, `wc`
- filtri testuali: `grep`, `awk`, `sed`, `cut`, `sort`, `uniq`
- pipeline e redirezioni: `|`, `>`, `>>`

### File/risultati tipici

- file `.txt`, `.tsv`, `.log`
- tabelle di conteggio o riepilogo
- estrazioni mirate da FASTQ/VCF/SAM

### Metriche che si ottengono velocemente da shell

- numero reads (ad es. `wc -l file.fastq` diviso 4)
- numero di varianti filtrate per criterio
- percentuali semplici (mapped/unmapped)

---

## 3) FastQC: controllo qualità iniziale

FastQC serve a capire se i dati grezzi sono “sani” prima di mappare.

### Input

- uno o più file `*.fastq` o `*.fastq.gz`

### Output

Per ciascun campione:

- `sample_fastqc.html` (report leggibile)
- `sample_fastqc.zip` (dati grezzi del report)

### Metriche/moduli da guardare sempre

- **Per base sequence quality**: andamento qualità lungo la read
- **Per sequence quality scores**: distribuzione globale dei quality score
- **Per base sequence content**: bilanciamento A/C/G/T
- **Sequence length distribution**: distribuzione delle lunghezze
- **Sequence duplication levels**: grado di duplicazione
- **Overrepresented sequences** e **Adapter content**: possibili contaminazioni/adapter residui

### Perché è decisivo

Un QC scarso porta facilmente a più mismatch, allineamenti meno affidabili e varianti meno robuste.

---

## 4) BWA: allineamento delle reads

BWA prende le reads e cerca la loro posizione più plausibile sul riferimento.

### Passo A — indicizzazione del riferimento

Comando tipico:

- `bwa index reference.fa`

File creati (indice):

- `reference.fa.amb`
- `reference.fa.ann`
- `reference.fa.bwt`
- `reference.fa.pac`
- `reference.fa.sa`

### Passo B — mapping

Comando tipico:

- `bwa mem reference.fa sample.fastq > sample.sam`

Output principale:

- `sample.sam`

### Cosa monitorare

- quante reads vengono processate
- quante si allineano / quante no
- qualità di mapping (MAPQ), da approfondire poi con SAMtools

---

## 5) SAMtools: dal SAM alle statistiche utili

SAMtools è fondamentale per lavorare in modo efficiente con gli allineamenti.

### Operazioni standard

1. conversione in BAM:
   - `samtools view -bS sample.sam > sample.bam`
2. ordinamento:
   - `samtools sort sample.bam -o sample.sorted.bam`
3. indicizzazione:
   - `samtools index sample.sorted.bam`

File prodotti:

- `sample.sorted.bam`
- `sample.sorted.bam.bai`

### Statistiche spesso usate

- `samtools flagstat sample.sorted.bam`
- `samtools idxstats sample.sorted.bam`
- `samtools depth sample.sorted.bam > depth.tsv`

### Metriche chiave da discutere

- numero totale di reads
- percentuale mapped
- reads properly paired (se paired-end)
- distribuzione per contig
- profondità per posizione

---

## 6) BCFtools: chiamata varianti

Con BCFtools passo dall'allineamento alle differenze rispetto al riferimento.

### Flusso tipico

1. pileup:
   - `bcftools mpileup -f reference.fa sample.sorted.bam -Ou > sample.bcf`
2. variant calling:
   - `bcftools call -mv -Ov sample.bcf > sample.vcf`

### Output

- `sample.bcf` (intermedio binario)
- `sample.vcf` (output leggibile e condivisibile)

### Cosa leggo nel VCF

- coordinate (`CHROM`, `POS`)
- allele di riferimento e alternativo (`REF`, `ALT`)
- qualità della chiamata (`QUAL`)
- annotazioni (`INFO`)
- genotipo campione (`FORMAT`, `GT`)

### Filtri comuni

- soglia minima su `QUAL`
- separazione SNP/INDEL
- confronto con varianti attese dell'esercitazione

---

## 7) BEDTools: copertura e regioni genomiche

BEDTools aiuta a quantificare bene la copertura, che è uno dei controlli più importanti.

Comando tipico:

- `bedtools genomecov -ibam sample.sorted.bam > coverage.txt`

### Output possibili

- distribuzione della copertura
- output per-base (a seconda delle opzioni)
- bedGraph per visualizzazioni

### Metriche utili

- profondità media
- percentuale di basi sopra una soglia (es. ≥10x)
- uniformità della copertura

---

## 8) R + tidyverse: sintesi e visualizzazione

Quando serve presentare i risultati in modo pulito, uso R/tidyverse per creare tabelle e grafici chiari.

### Input tipici

- `depth.tsv`
- tabelle derivate da FastQC
- tabelle ottenute da VCF/SAMtools

### Output tipici

- grafici (PNG/PDF)
- tabelle riassuntive (CSV/TSV)
- piccole sezioni di report

### Metriche che conviene riassumere

- media/mediana della profondità
- numero varianti per classe (SNP vs INDEL)
- distribuzione per cromosoma o regione

---

## 9) IGV in notebook: ispezione visuale di BAM/VCF

Per validare meglio una variante candidata, durante l'esercitazione possiamo aprire l'allineamento in **IGV** direttamente nel notebook con `igv-notebook` (quindi nel browser, senza GUI desktop).

### Quando usarlo

- controllo visuale di una posizione variante (supporto read-level)
- verifica di copertura locale e possibili bias
- confronto rapido tra BAM allineato e VCF chiamato

### Esempio minimo (in una cella Python)

Per i casi del corso usa la procedura operativa completa in `cases/students/guida_unica.md` (sezione 9.5), dove trovi i comandi esatti con solo `CASE_NUM` da cambiare.

Qui lasciamo solo la regola generale:
- inizializza `igv_notebook` in cella Jupyter,
- usa un `reference` con `fastaURL` + `indexURL` per riferimenti custom,
- carica BAM/BAI e VCF (meglio `.vcf.gz` + `.tbi`) come track.

### Nota pratica per i nostri casi

Nei casi di questo repository il riferimento è mock (`data/reference/mock_reference.fa`) e richiede indice FASTA `.fai` per uso stabile in IGV notebook.

---

## Formati file che bisogna saper riconoscere

- **FASTA (`.fa`)**: riferimento
- **FASTQ (`.fastq`)**: reads + qualità per base
- **SAM/BAM (`.sam`, `.bam`)**: allineamenti
- **BAI (`.bai`)**: indice BAM
- **VCF/BCF (`.vcf`, `.bcf`)**: varianti
- **GFF/BED/TSV**: annotazioni e tabelle di supporto

---

## Checklist finale (pratica)

Prima di considerare conclusa un'analisi, conviene verificare:

1. qualità reads accettabile (FastQC)
2. percentuale di mapping coerente
3. copertura sufficiente e non troppo sbilanciata
4. varianti con qualità adeguata
5. coerenza con i risultati attesi del caso studio

Questa sequenza, semplice ma rigorosa, è il cuore dell'esercitazione: dai dati grezzi a un risultato interpretabile.
