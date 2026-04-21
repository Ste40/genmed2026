# Caso 4 — Copertura ridotta e rischio falsi negativi

**Input:** `data/dataset4/sample4.fastq`

## Obiettivo didattico
Imparare a leggere e motivare risultati in un campione con coverage limitata.

## Step operativi
```bash
CASE=case04
FASTQ=data/dataset4/sample4.fastq
REF=data/reference/mock_reference.fa
OUT=results/$CASE
mkdir -p $OUT

fastqc -o $OUT $FASTQ

bwa mem $REF $FASTQ | samtools sort -o $OUT/aln.sorted.bam
samtools index $OUT/aln.sorted.bam

samtools depth $OUT/aln.sorted.bam > $OUT/depth.tsv
awk '{sum+=$3; n++} END{print "MeanDepth",sum/n}' $OUT/depth.tsv > $OUT/depth_summary.txt

bcftools mpileup -f $REF $OUT/aln.sorted.bam -Ou |
  bcftools call -mv -Ov -o $OUT/raw.vcf

# filtro meno stringente per non perdere segnali reali
bcftools filter -i 'QUAL>=20 && DP>=6' $OUT/raw.vcf -Ov -o $OUT/final.vcf
```

## Checklist interpretativa
- Valutare profondità media e zone a depth bassa.
- Motivare perché un filtro troppo severo può introdurre falsi negativi.
- Verificare presenza della variante causativa nonostante bassa copertura.
