# Caso 3 — Reads corte e trimming adattivo

**Input:** `data/dataset3/sample3.fastq`

## Obiettivo didattico
Capire l'impatto di reads corte/spezzate su allineamento e chiamata varianti.

## Step operativi
```bash
CASE=case03
FASTQ=data/dataset3/sample3.fastq
REF=data/reference/mock_reference.fa
OUT=results/$CASE
mkdir -p $OUT

fastqc -o $OUT $FASTQ

# Opzione A: nessun filtro
bwa mem $REF $FASTQ | samtools sort -o $OUT/aln.raw.sorted.bam
samtools index $OUT/aln.raw.sorted.bam

# Opzione B: tieni solo reads >=70 bp
seqtk seq -L 70 $FASTQ > $OUT/sample3.min70.fastq
bwa mem $REF $OUT/sample3.min70.fastq | samtools sort -o $OUT/aln.min70.sorted.bam
samtools index $OUT/aln.min70.sorted.bam

# Chiamata varianti su entrambi i BAM
for B in raw min70; do
  bcftools mpileup -f $REF $OUT/aln.$B.sorted.bam -Ou |
    bcftools call -mv -Ov -o $OUT/$B.vcf
done
```

## Checklist interpretativa
- Confrontare mapping rate e profondità tra raw e min70.
- Verificare se il filtro lunghezza riduce rumore senza perdere la variante causativa.
- Discutere compromesso sensibilità vs specificità.
