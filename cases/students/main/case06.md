# Caso 06

## Scenario clinico (mock)

Paziente con sospetto di malattia genetica rara in pannello mirato. Il clinico segnala come priorità diagnostica: **una SNV in gene1**.

> Obiettivo: eseguire la pipeline bioinformatica completa e discutere se i dati supportano o no l'ipotesi clinica.

## Dataset assegnato

- FASTQ: `data/dataset6/sample6.fastq`
- Riferimento: `data/reference/mock_reference.fa`
- Annotazione geni mock: `data/reference/mock_annotation.gff`

## Setup rapido

```bash
cd $HOME
CASE=case06
FASTQ=data/dataset6/sample6.fastq
REF=data/reference/mock_reference.fa
OUT=results/$CASE
mkdir -p "$OUT/fastqc"
```

## Formati file che userai

- **FASTQ**: sequenze + qualità per read.
- **SAM/BAM**: allineamenti (BAM è la versione binaria/indicizzata).
- **VCF**: elenco varianti candidate.
- **TSV**: tabelle metriche (profondità, conteggi).

## Workflow suggerito (con comandi esempio)

1. **QC iniziale**
```bash
fastqc -o "$OUT/fastqc" "$FASTQ"
```
Domande:
- Qual è la lunghezza media delle reads?
- Ci sono warning su qualità per base, adapter o distribuzione lunghezze?
- Quante reads totali sono presenti?

2. **Pulizia/filtri (se necessari in base al QC)**
```bash
cutadapt -u -3 -o "$OUT/clean.fastq" "$FASTQ" > "$OUT/cutadapt.log"
```
Domande:
- Hai applicato un filtro? Perché?
- Quante reads rimangono dopo il preprocessing?

3. **Allineamento**
```bash
bwa index "$REF"
samtools faidx "$REF"
bwa mem "$REF" "$OUT/clean.fastq" | samtools sort -o "$OUT/aln.sorted.bam"
samtools index "$OUT/aln.sorted.bam"
samtools flagstat "$OUT/aln.sorted.bam" > "$OUT/flagstat.txt"
```
Domande:
- Percentuale di reads mappate correttamente?
- Ci sono segnali di copertura insufficiente su regioni di interesse?

4. **Variant calling**
```bash
bcftools mpileup -f "$REF" "$OUT/aln.sorted.bam" -Ou |   bcftools call -mv -Ov -o "$OUT/raw.vcf"
bcftools filter -i 'QUAL>=20 && DP>=6' "$OUT/raw.vcf" -Ov -o "$OUT/final_lenient.vcf"
```
Domande:
- Quante varianti totali trovi nel raw VCF?
- Quante restano dopo il filtro?
- Che tipi di varianti osservi (SNV/INDEL/delezioni/inserzioni)?

5. **Interpretazione clinica guidata**
- Confronta varianti finali con il sospetto diagnostico indicato.
- Verifica gene/locus (in base a `mock_annotation.gff`) e qualità (QUAL, DP).
- Motiva la scelta finale o la necessità di ripetere il sequenziamento.

Per i dettagli generali consulta: [Guida unica studenti](../guida_unica.md).
