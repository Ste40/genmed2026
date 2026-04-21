# Caso 8 (riserva) — Duplicati PCR estremi

**Input:** `data/dataset8/sample8.fastq`

## Scenario
Dataset con forte over-representation di reads identiche (duplicati PCR).

## Step operativi
```bash
CASE=case08
FASTQ=data/dataset8/sample8.fastq
REF=data/reference/mock_reference.fa
OUT=results/$CASE
mkdir -p $OUT

fastqc -o $OUT $FASTQ

# deduplicazione a livello FASTQ
seqkit rmdup -s $FASTQ -o $OUT/sample8.dedup.fastq

# confronto dimensioni
printf 'Raw reads:   '; awk 'END{print NR/4}' $FASTQ
printf 'Dedup reads: '; awk 'END{print NR/4}' $OUT/sample8.dedup.fastq

bwa mem $REF $OUT/sample8.dedup.fastq | samtools sort -o $OUT/aln.sorted.bam
samtools index $OUT/aln.sorted.bam

bcftools mpileup -f $REF $OUT/aln.sorted.bam -Ou |
  bcftools call -mv -Ov -o $OUT/final.vcf
```

## Discussione
- Quantificare la percentuale di duplicati rimossi.
- Verificare che la variante causativa resti supportata dopo deduplicazione.
