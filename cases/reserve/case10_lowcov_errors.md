# Caso 10 (riserva) — Bassa copertura e errori sporadici

**Input:** `data/dataset10/sample10.fastq`

## Scenario
Campione con poche reads complessive e piccoli errori sparsi: alto rischio di chiamate instabili.

## Step operativi
```bash
CASE=case10
FASTQ=data/dataset10/sample10.fastq
REF=data/reference/mock_reference.fa
OUT=results/$CASE
mkdir -p $OUT

fastqc -o $OUT $FASTQ

bwa mem $REF $FASTQ | samtools sort -o $OUT/aln.sorted.bam
samtools index $OUT/aln.sorted.bam
samtools depth $OUT/aln.sorted.bam > $OUT/depth.tsv

bcftools mpileup -f $REF $OUT/aln.sorted.bam -Ou |
  bcftools call -mv -Ov -o $OUT/raw.vcf

# doppio filtro per confronto
bcftools filter -i 'QUAL>=15 && DP>=4'  $OUT/raw.vcf -Ov -o $OUT/lenient.vcf
bcftools filter -i 'QUAL>=30 && DP>=10' $OUT/raw.vcf -Ov -o $OUT/strict.vcf
```

## Discussione
- Confrontare lenient vs strict e motivare la scelta finale.
- Esplicitare il rischio di perdere varianti reali in low coverage.
- Verificare la variante causativa attesa (sample10 ~ sample4).
