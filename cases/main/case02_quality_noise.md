# Caso 2 — Rumore di qualità e filtri QUAL/DP

**Input:** `data/dataset2/sample2.fastq`

## Obiettivo didattico
Gestire un dataset con qualità non omogenea, evitando falsi positivi tramite filtri sul VCF.

## Step operativi
```bash
CASE=case02
FASTQ=data/dataset2/sample2.fastq
REF=data/reference/mock_reference.fa
OUT=results/$CASE
mkdir -p $OUT

fastqc -o $OUT $FASTQ

# Pipeline base
bwa mem $REF $FASTQ | samtools sort -o $OUT/aln.sorted.bam
samtools index $OUT/aln.sorted.bam

bcftools mpileup -f $REF $OUT/aln.sorted.bam -Ou |
  bcftools call -mv -Ov -o $OUT/raw.vcf

# Filtraggio progressivo
bcftools filter -i 'QUAL>=20 && DP>=8'  $OUT/raw.vcf -Ov -o $OUT/lenient.vcf
bcftools filter -i 'QUAL>=30 && DP>=10' $OUT/raw.vcf -Ov -o $OUT/strict.vcf

# Confronto rapido
printf 'Lenient: '; bcftools view -H $OUT/lenient.vcf | wc -l
printf 'Strict : '; bcftools view -H $OUT/strict.vcf  | wc -l
```

## Checklist interpretativa
- Confrontare numero di varianti tra filtri lenient/strict.
- Motivare quale set è più affidabile rispetto all'obiettivo clinico/sperimentale.
- Verificare che la variante causativa rimanga dopo il filtro scelto.
