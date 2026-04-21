# Caso 1

**Dataset assegnato:** `data/dataset1/sample1.fastq`

## Obiettivo del caso
Eseguire un'analisi end-to-end da FASTQ a VCF, motivando ogni scelta di QC, filtraggio e interpretazione.

## Software usati (e perché)
- **FastQC**: controlla qualità per base, distribuzione lunghezze, sequenze sovra-rappresentate e altri indicatori QC.
- **BWA-MEM**: allinea le reads al genoma di riferimento.
- **samtools**: converte/ordina/indicizza BAM e calcola metriche di allineamento.
- **bcftools**: esegue mpileup, chiama varianti e filtra VCF.
- **Tool opzionali di cleaning** (`cutadapt`, `seqtk`, `seqkit`, mini-script Python): usali solo se il QC suggerisce un problema.

## Workflow consigliato (con motivazione)

### 1) Setup
```bash
CASE=case01
FASTQ=data/dataset1/sample1.fastq
REF=data/reference/mock_reference.fa
OUT=results/$CASE
mkdir -p $OUT/fastqc
```
**Perché:** variabili coerenti e output organizzato rendono l'analisi riproducibile.

### 2) Quality control iniziale
```bash
fastqc -o $OUT/fastqc $FASTQ
```
**Perché:** prima di toccare i dati devi capire se c'è qualcosa da correggere.

### 3) Ispezione dei report FastQC (anche da terminale)
```bash
# Elenco file prodotti
ls -lh $OUT/fastqc

# Estrarre report testuale dal file zip
unzip -p $OUT/fastqc/*_fastqc.zip */summary.txt
unzip -p $OUT/fastqc/*_fastqc.zip */fastqc_data.txt | head -n 80
```
**Perché:** puoi ispezionare i risultati senza uscire dal terminale; in Jupyter puoi anche aprire l'HTML del report.

> Nota importante per questo dataset sintetico: `sample1.fastq` usa qualità costante con solo il carattere ASCII `I`.
> In alcuni run FastQC può etichettare l'encoding come "Illumina 1.5", mostrando un valore apparente ~9 per base.
> Non è un degrado reale della qualità lungo la read: è un effetto di ambiguità dell'auto-detection su un file monocromatico.
> Per verifica rapida da terminale:
> ```bash
> awk 'NR%4==0{print; exit}' $FASTQ | od -An -tu1
> ```
> Se osservi `73` (ASCII `I`) e il dataset è stato generato in Phred+33, quel valore corrisponde a Q=40.

### 4) (Decisione guidata dal QC) eventuale pulizia reads
Se FastQC indica criticità, applica una delle strategie sotto e salva in `$OUT/clean.fastq`:

```bash
# A) trimming qualità + lunghezza minima
cutadapt -q 20 -m 70 -o $OUT/clean.fastq $FASTQ > $OUT/cutadapt.log

# B) filtro per lunghezza minima
seqtk seq -L 70 $FASTQ > $OUT/clean.fastq

# C) deduplicazione sequenze identiche
seqkit rmdup -s $FASTQ -o $OUT/clean.fastq
```
**Perché:** la pulizia migliora specificità/sensibilità solo se scelta in base all'evidenza QC.

> Se non fai cleaning, usa direttamente `FASTQ` nel passo successivo.

### 5) Allineamento e preparazione BAM
```bash
INPUT_FOR_ALIGNMENT=${OUT}/clean.fastq
[ -s "$INPUT_FOR_ALIGNMENT" ] || INPUT_FOR_ALIGNMENT=$FASTQ

bwa index $REF
bwa mem $REF $INPUT_FOR_ALIGNMENT | samtools sort -o $OUT/aln.sorted.bam
samtools index $OUT/aln.sorted.bam
samtools flagstat $OUT/aln.sorted.bam > $OUT/flagstat.txt
samtools depth $OUT/aln.sorted.bam > $OUT/depth.tsv
```
**Perché:** BAM ordinato+indicizzato è necessario per mpileup; `flagstat` e `depth` spiegano qualità dell'allineamento.

### 6) Variant calling
```bash
bcftools mpileup -f $REF $OUT/aln.sorted.bam -Ou |
  bcftools call -mv -Ov -o $OUT/raw.vcf
```
**Perché:** `mpileup` costruisce l'evidenza per-base, `call` identifica SNP/indel candidati.

### 7) Filtraggio varianti e confronto strategie
```bash
bcftools filter -i 'QUAL>=20 && DP>=6'  $OUT/raw.vcf -Ov -o $OUT/final_lenient.vcf
bcftools filter -i 'QUAL>=30 && DP>=10' $OUT/raw.vcf -Ov -o $OUT/final_strict.vcf
```
**Perché:** confrontare filtri diversi aiuta a capire trade-off tra sensibilità e specificità.

### 8) Interpretazione finale
```bash
bcftools view -H $OUT/final_lenient.vcf
bcftools view -H $OUT/final_strict.vcf
```
Confronta le varianti finali con `data/reference/causative_variants.tsv` e giustifica:
1. quali step di pulizia hai applicato (o evitato),
2. quale filtro VCF ritieni più adatto,
3. quali evidenze supportano la variante finale.

### 9) Attività extra: annotazione su gene mock e copertura
```bash
ANNOT=data/reference/mock_annotation.gff

# 1) Estrai la/e variante/i finali che cadono in feature annotate (gene/CDS/exon)
bedtools intersect -header -wa -a $OUT/final_lenient.vcf -b $ANNOT > $OUT/final_lenient.annotated.vcf

# 2) Calcola la copertura media sulle feature annotate del gene mock
bedtools coverage -a $ANNOT -b $OUT/aln.sorted.bam -mean > $OUT/mock_gene_coverage.tsv

# 3) Visualizza rapidamente le feature con copertura più bassa
sort -k10,10n $OUT/mock_gene_coverage.tsv | head
```
**Perché:** questa verifica aggiunge contesto biologico (dove cade la variante) e permette di valutare se la regione genica mock ha copertura sufficiente per fidarsi dell'interpretazione finale.
