# Guida unica studenti (workflow standard)

Questa guida è comune a tutti i casi.

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
- Percentuale di reads mappate?
- Profondità media?

## 5) Variant calling (filtri opzionali)

```bash
bcftools mpileup -f "$REF" "$OUT/aln.sorted.bam" -Ou | \
  bcftools call -mv -Ob -o "$OUT/raw.bcf"

bcftools view "$OUT/raw.bcf" -Ov -o "$OUT/raw.vcf"

# Opzionale (esempi): filtri qualità per confrontare l'effetto
# bcftools filter -i 'QUAL>=20 && DP>=6' "$OUT/raw.bcf" -Ov -o "$OUT/final_lenient.vcf"
# bcftools filter -i 'QUAL>=30 && DP>=10' "$OUT/raw.bcf" -Ov -o "$OUT/final_strict.vcf"
```

Domande guida:
- Quante varianti pre-filtering?
- Che tipo di varianti sono state identificate nel raw VCF?
- Se applichi i filtri opzionali, cosa cambia?

## 6) Contestualizzazione su geni mock

```bash
ANNOT=data/reference/mock_annotation.gff
bedtools intersect -header -wa -a "$OUT/raw.vcf" -b "$ANNOT" > "$OUT/raw.annotated.vcf"
bedtools coverage -a "$ANNOT" -b "$OUT/aln.sorted.bam" -mean > "$OUT/mock_gene_coverage.tsv"
```

Domande guida:
- Le varianti candidate (raw VCF) cadono nel gene sospetto?
- Serve conferma tecnica o re-sequenziamento?

## 7) Apertura IGV notebook (verifica visiva di copertura e varianti)

Per verificare rapidamente regioni poco coperte o confermare varianti candidate a livello read-level:

Domanda guida (dopo ispezione in IGV e calcolo coverage per gene):
- Ci sono segnali di copertura insufficiente su regioni di interesse?

```python
import igv_notebook
igv_notebook.init()

CASE = "case01"

b = igv_notebook.Browser({
    "reference": {
        "id": "mock_ref",
        "name": "Mock reference",
        "fastaURL": "/data/reference/mock_reference.fa",
        "indexURL": "/data/reference/mock_reference.fa.fai"
    },
    "locus": "mock_chromosome:50-150",
    "tracks": [
        {
            "name": f"{CASE} BAM",
            "url": f"/results/{CASE}/aln.sorted.bam",
            "indexURL": f"/results/{CASE}/aln.sorted.bam.bai",
            "format": "bam",
            "type": "alignment"
        },
        {
            "name": f"{CASE} raw VCF",
            "url": f"/results/{CASE}/raw.vcf",
            "format": "vcf",
            "type": "variant",
            "displayMode": "EXPANDED"
        },
        {
            "name": "Mock annotation",
            "url": "/data/reference/mock_annotation.gff",
            "format": "gff",
            "type": "annotation",
            "displayMode": "EXPANDED",
            "height": 120
        }
    ]
})

b
```

Suggerimento: prima di lanciare IGV assicurati di avere `samtools index "$OUT/aln.sorted.bam"` e di aver già creato `"$OUT/raw.vcf"`.
