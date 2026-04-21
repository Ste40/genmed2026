# Caso 1 — Pipeline baseline e verifica del risultato

**Input:** `data/dataset1/sample1.fastq`

## Obiettivo didattico
Eseguire il workflow completo senza correzioni aggressive e validare la variante causativa finale.

## Step operativi
```bash
CASE=case01
FASTQ=data/dataset1/sample1.fastq
REF=data/reference/mock_reference.fa
OUT=results/$CASE
mkdir -p $OUT

fastqc -o $OUT $FASTQ

bwa index $REF
bwa mem $REF $FASTQ | samtools sort -o $OUT/aln.sorted.bam
samtools index $OUT/aln.sorted.bam
samtools flagstat $OUT/aln.sorted.bam > $OUT/flagstat.txt

bcftools mpileup -f $REF $OUT/aln.sorted.bam -Ou |
  bcftools call -mv -Ov -o $OUT/raw.vcf

bcftools filter -i 'QUAL>=30 && DP>=10' $OUT/raw.vcf -Ov -o $OUT/final.vcf
bcftools view -H $OUT/final.vcf
```

## Checklist interpretativa
- Il report FastQC deve essere globalmente buono.
- Nel VCF finale ci si aspetta una variante forte (AF alta, profondità adeguata).
- Confrontare posizione/alleli con `data/reference/causative_variants.tsv`.
