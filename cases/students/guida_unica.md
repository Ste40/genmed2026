# Guida unica studenti (workflow standard)

Questa guida è comune a tutti i casi e non contiene la soluzione diagnostica.

## 1) Setup

```bash
cd $HOME
CASE=case01
FASTQ=data/dataset1/sample1.fastq
REF=data/reference/mock_reference.fa
OUT=results/$CASE
mkdir -p "$OUT/fastqc"
```

## 2) Quality Control (FastQC)

```bash
fastqc -o "$OUT/fastqc" "$FASTQ"
```

Domande guida:
- Numero reads totale?
- Lunghezza media/mediana?
- Adapter content presente?
- Segnali di bassa qualità terminale?

## 3) Cleaning (solo se il QC lo suggerisce)

Esempi rapidi:

```bash
# Nessuna pulizia
cp "$FASTQ" "$OUT/clean.fastq"

# Trimming qualità e lunghezza minima
cutadapt -q 20 -m 80 -o "$OUT/clean.fastq" "$FASTQ" > "$OUT/cutadapt.log"

# Rimozione adapter noto
cutadapt -a AGATCGGAAGAGC -o "$OUT/clean.fastq" "$FASTQ" > "$OUT/cutadapt.log"

# Rimozione ultime 3 basi
cutadapt -u -3 -o "$OUT/clean.fastq" "$FASTQ" > "$OUT/cutadapt.log"

# Filtro lunghezza
seqtk seq -L 80 "$FASTQ" > "$OUT/clean.fastq"
```

## 4) Allineamento e metriche BAM

```bash
bwa index "$REF"
samtools faidx "$REF"
bwa mem "$REF" "$OUT/clean.fastq" | samtools sort -o "$OUT/aln.sorted.bam"
samtools index "$OUT/aln.sorted.bam"
samtools flagstat "$OUT/aln.sorted.bam" > "$OUT/flagstat.txt"
samtools depth "$OUT/aln.sorted.bam" > "$OUT/depth.tsv"
```

Domande guida:
- Percentuale mapped?
- Profondità media?
- Zone con copertura molto bassa?

## 5) Variant calling e filtro

```bash
bcftools mpileup -f "$REF" "$OUT/aln.sorted.bam" -Ou | \
  bcftools call -mv -Ov -o "$OUT/raw.vcf"

bcftools filter -i 'QUAL>=20 && DP>=6' "$OUT/raw.vcf" -Ov -o "$OUT/final_lenient.vcf"
bcftools filter -i 'QUAL>=30 && DP>=10' "$OUT/raw.vcf" -Ov -o "$OUT/final_strict.vcf"
```

Domande guida:
- Quante varianti raw?
- Quante varianti dopo filtri?
- Quante SNV vs INDEL?

## 6) Contestualizzazione su geni mock

```bash
ANNOT=data/reference/mock_annotation.gff
bedtools intersect -header -wa -a "$OUT/final_lenient.vcf" -b "$ANNOT" > "$OUT/final_lenient.annotated.vcf"
bedtools coverage -a "$ANNOT" -b "$OUT/aln.sorted.bam" -mean > "$OUT/mock_gene_coverage.tsv"
```

Domande guida:
- Le varianti finali cadono nel gene sospetto?
- Il supporto (DP/QUAL) è sufficiente per una conclusione?
- Serve conferma tecnica o re-sequenziamento?
