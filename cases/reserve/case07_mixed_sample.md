# Caso 7 (riserva) — Campione misto con due segnali reali

**Input:** `data/dataset7/sample7.fastq`

## Scenario
Il campione è una miscela di due origini biologiche: ci si aspetta più di una variante ad alta AF.

## Step operativi
```bash
CASE=case07
FASTQ=data/dataset7/sample7.fastq
REF=data/reference/mock_reference.fa
OUT=results/$CASE
mkdir -p $OUT

fastqc -o $OUT $FASTQ

bwa mem $REF $FASTQ | samtools sort -o $OUT/aln.sorted.bam
samtools index $OUT/aln.sorted.bam

bcftools mpileup -f $REF $OUT/aln.sorted.bam -Ou |
  bcftools call -mv -Ov -o $OUT/raw.vcf

# tieni varianti supportate da buona evidenza
bcftools filter -i 'QUAL>=30 && DP>=10 && AF>=0.2' $OUT/raw.vcf -Ov -o $OUT/final.vcf
bcftools view -H $OUT/final.vcf
```

## Discussione
- Aspettarsi due varianti plausibili invece di una sola.
- Discutere perché AF intermedia può indicare campione misto o mosaicismo.
