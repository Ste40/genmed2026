# Caso 4

**Dataset assegnato:** `data/dataset4/sample4.fastq`

## Obiettivo del caso
Eseguire un'analisi end-to-end da FASTQ a VCF, motivando ogni scelta di QC, filtraggio e interpretazione.

## Software usati (e perché)
- **FastQC**: controlla qualità per base, distribuzione lunghezze, sequenze sovra-rappresentate e altri indicatori QC.
- **BWA-MEM**: allinea le reads al genoma di riferimento.
- **samtools**: converte/ordina/indicizza BAM e calcola metriche di allineamento.
- **bcftools**: esegue mpileup, chiama varianti e filtra VCF.
- **Tool opzionali di cleaning** (`cutadapt`, `seqtk`, mini-script Python): usali solo se il QC suggerisce un problema.

## Workflow consigliato (con motivazione)

### 1) Setup
```bash
CASE=case04
FASTQ=data/dataset4/sample4.fastq
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

### 4) (Decisione guidata dal QC) eventuale pulizia reads
Se FastQC indica criticità, applica **una** delle strategie sotto e salva in `$OUT/clean.fastq` (sovrascrivendo il file).
Se **non** ci sono criticità, crea comunque il file pulito come copia 1:1 dell'input per mantenere il workflow coerente:

```bash
cp $FASTQ $OUT/clean.fastq

# A) trimming qualità + lunghezza minima
cutadapt -q 20 -m 70 -o $OUT/clean.fastq $FASTQ > $OUT/cutadapt.log

# B) filtro per lunghezza minima
seqtk seq -L 70 $FASTQ > $OUT/clean.fastq
```
**Perché:** la pulizia migliora specificità/sensibilità solo se scelta in base all'evidenza QC; rimuovere sequenze identiche non è raccomandato in questo contesto didattico perché può eliminare reads biologicamente legittime.

### 5) Allineamento e preparazione BAM
```bash
INPUT_FOR_ALIGNMENT=${OUT}/clean.fastq
[ -s "$INPUT_FOR_ALIGNMENT" ] || { echo "Errore: manca $INPUT_FOR_ALIGNMENT. Esegui prima lo step 4."; exit 1; }

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
