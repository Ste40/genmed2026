# Caso 6 (riserva) — Contaminazione da adapter 3'

**Input:** `data/dataset6/sample6.fastq`

## Scenario
Una parte delle reads contiene sequenze adapter in coda e qualità terminale molto bassa.

## Step operativi
```bash
CASE=case06
FASTQ=data/dataset6/sample6.fastq
REF=data/reference/mock_reference.fa
OUT=results/$CASE
mkdir -p $OUT

fastqc -o $OUT $FASTQ

# trimming adapter + quality trimming
cutadapt -a AGATCGGAAGAGC -q 20 -m 70 -o $OUT/sample6.trimmed.fastq $FASTQ > $OUT/cutadapt.log

fastqc -o $OUT $OUT/sample6.trimmed.fastq

bwa mem $REF $OUT/sample6.trimmed.fastq | samtools sort -o $OUT/aln.sorted.bam
samtools index $OUT/aln.sorted.bam

bcftools mpileup -f $REF $OUT/aln.sorted.bam -Ou |
  bcftools call -mv -Ov -o $OUT/final.vcf
```

## Discussione
- Confrontare FastQC pre/post trimming.
- Verificare se l'overrepresented sequence (adapter) scompare.
- Controllare la variante causativa attesa (sample6 ~ sample2).
