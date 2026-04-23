# Documento operativo: file, formati e tool dell'esercitazione

## 1) File che vedranno gli studenti

### Input principali
- `data/datasetX/sampleX.fastq`: reads grezze del caso assegnato.
- `data/reference/mock_reference.fa`: genoma di riferimento mock.
- `data/reference/mock_annotation.gff`: coordinate dei geni mock (gene1, gene2, gene3).

### Output attesi in `results/<case>/`
- `fastqc/*_fastqc.html` e `*_fastqc.zip`
- `clean.fastq` (se creato)
- `aln.sorted.bam` + `aln.sorted.bam.bai`
- `flagstat.txt`, `depth.tsv`
- `raw.vcf`, `final_lenient.vcf`, `final_strict.vcf`
- `final_lenient.annotated.vcf`, `mock_gene_coverage.tsv`

## 2) Formati file (in modo semplice)

- **FASTA (`.fa`)**: sequenza di riferimento; righe con `>` indicano il nome del contig.
- **FASTQ (`.fastq`)**: 4 righe per read (header, sequenza, `+`, qualità ASCII).
- **SAM/BAM**: allineamenti delle reads sul riferimento.
- **BAI**: indice del BAM per accesso veloce alle posizioni.
- **VCF (`.vcf`)**: varianti candidate con coordinate e metriche (QUAL, DP, ecc.).
- **GFF (`.gff`)**: annotazioni di feature genomiche (qui: geni mock).
- **TSV (`.tsv`)**: tabelle testuali separate da tab.

## 3) Tool installati (e uso minimo)

## FastQC
Valuta qualità del FASTQ.
```bash
fastqc -o results/case01/fastqc data/dataset1/sample1.fastq
```

## cutadapt
Trimming qualità/adapter/code terminali.
```bash
cutadapt -q 20 -m 80 -o results/case01/clean.fastq data/dataset1/sample1.fastq
cutadapt -a AGATCGGAAGAGC -o results/case04/clean.fastq data/dataset4/sample4.fastq
cutadapt -u -3 -o results/case06/clean.fastq data/dataset6/sample6.fastq
```

## seqtk
Filtro per lunghezza minima reads.
```bash
seqtk seq -L 80 data/dataset2/sample2.fastq > results/case02/clean.fastq
```

## BWA
Allineamento reads al riferimento.
```bash
bwa index data/reference/mock_reference.fa
bwa mem data/reference/mock_reference.fa results/case01/clean.fastq > results/case01/aln.sam
```

## SAMtools
Conversione, ordinamento, indice e metriche BAM.
```bash
samtools sort results/case01/aln.sam -o results/case01/aln.sorted.bam
samtools index results/case01/aln.sorted.bam
samtools flagstat results/case01/aln.sorted.bam > results/case01/flagstat.txt
samtools depth results/case01/aln.sorted.bam > results/case01/depth.tsv
```

## BCFtools
Variant calling e filtro qualità.
```bash
bcftools mpileup -f data/reference/mock_reference.fa results/case01/aln.sorted.bam -Ou | \
  bcftools call -mv -Ov -o results/case01/raw.vcf
bcftools filter -i 'QUAL>=20 && DP>=6' results/case01/raw.vcf -Ov -o results/case01/final_lenient.vcf
```

## BEDTools
Intersezione varianti-annotazione e copertura per gene.
```bash
bedtools intersect -header -wa -a results/case01/final_lenient.vcf -b data/reference/mock_annotation.gff > results/case01/final_lenient.annotated.vcf
bedtools coverage -a data/reference/mock_annotation.gff -b results/case01/aln.sorted.bam -mean > results/case01/mock_gene_coverage.tsv
```
