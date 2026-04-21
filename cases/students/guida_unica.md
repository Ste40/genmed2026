# Guida unica studenti (valida per tutti i casi)

Questa guida sostituisce le istruzioni duplicate per ogni case e descrive un workflow completo, didattico e riproducibile da FASTQ a VCF.

## Quando usare questa guida
Usala per **qualsiasi dataset assegnato** (`dataset1` ... `dataset10`), cambiando solo le variabili iniziali.

---

## 1) Setup generale
Imposta il numero del caso e il FASTQ assegnato.

```bash
# Spostati automaticamente alla root del repository (da qualunque sottocartella)
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "Errore: esegui i comandi dentro la repo."; exit 1; }
cd "$REPO_ROOT"

CASE=case01
FASTQ=data/dataset1/sample1.fastq
REF=data/reference/mock_reference.fa
OUT=results/$CASE
mkdir -p "$OUT/fastqc"
[ -r "$FASTQ" ] || { echo "Errore: FASTQ non trovato: $FASTQ"; exit 1; }
```

> Per gli altri casi cambia solo `CASE` e `FASTQ` (es. `case07` + `data/dataset7/sample7.fastq`).

**Perché:** variabili coerenti e output organizzato rendono l'analisi riproducibile.

## 2) Quality control iniziale
```bash
fastqc -o "$OUT/fastqc" "$FASTQ"
```

Apri il report HTML (`$OUT/fastqc/*_fastqc.html`) e interpreta almeno:
- qualità per base,
- distribuzione lunghezze,
- contenuto GC,
- sequenze sovra-rappresentate.

**Perché:** prima di modificare i dati, devi capire se esistono criticità reali.

## 3) Cleaning guidato dal QC (solo se serve)
Se non ci sono criticità, mantieni un file di input coerente copiando 1:1:

```bash
cp $FASTQ $OUT/clean.fastq
```

Se il QC mostra problemi, applica **una** strategia:

```bash
# A) trimming qualità + lunghezza minima
cutadapt -q 20 -m 70 -o $OUT/clean.fastq $FASTQ > $OUT/cutadapt.log

# B) filtro sola lunghezza minima
seqtk seq -L 70 $FASTQ > $OUT/clean.fastq
```

**Perché:** la pulizia va fatta solo con evidenza QC; deduplicare per sequenza identica in questo contesto didattico può rimuovere reads biologicamente plausibili.

## 4) Allineamento e preparazione BAM
```bash
INPUT_FOR_ALIGNMENT=${OUT}/clean.fastq
[ -s "$INPUT_FOR_ALIGNMENT" ] || { echo "Errore: manca $INPUT_FOR_ALIGNMENT. Esegui prima lo step 3."; exit 1; }

bwa index $REF
bwa mem $REF $INPUT_FOR_ALIGNMENT | samtools sort -o $OUT/aln.sorted.bam
samtools index $OUT/aln.sorted.bam
samtools flagstat $OUT/aln.sorted.bam > $OUT/flagstat.txt
samtools depth $OUT/aln.sorted.bam > $OUT/depth.tsv
```

**Perché:** BAM ordinato+indicizzato è necessario per `mpileup`; `flagstat` e `depth` aiutano a interpretare qualità e copertura.

## 5) Variant calling
```bash
bcftools mpileup -f $REF $OUT/aln.sorted.bam -Ou |   bcftools call -mv -Ov -o $OUT/raw.vcf
```

**Perché:** `mpileup` costruisce l'evidenza per-base, `call` identifica SNP/indel candidati.

## 6) Filtraggio varianti: confronto lenient vs strict
```bash
bcftools filter -i 'QUAL>=20 && DP>=6'  $OUT/raw.vcf -Ov -o $OUT/final_lenient.vcf
bcftools filter -i 'QUAL>=30 && DP>=10' $OUT/raw.vcf -Ov -o $OUT/final_strict.vcf
```

**Perché:** confrontare filtri diversi chiarisce il trade-off sensibilità/specificità.

## 7) Interpretazione finale
```bash
bcftools view -H $OUT/final_lenient.vcf
bcftools view -H $OUT/final_strict.vcf
```

Confronta i risultati con `data/reference/causative_variants.tsv` e giustifica:
1. quali passaggi di cleaning hai applicato (o evitato),
2. quale filtro VCF ritieni più adatto,
3. quali evidenze sostengono la variante finale.

## 8) Extra: annotazione su gene mock e copertura
```bash
ANNOT=data/reference/mock_annotation.gff

bedtools intersect -header -wa -a $OUT/final_lenient.vcf -b $ANNOT > $OUT/final_lenient.annotated.vcf
bedtools coverage -a $ANNOT -b $OUT/aln.sorted.bam -mean > $OUT/mock_gene_coverage.tsv
sort -k10,10n $OUT/mock_gene_coverage.tsv | head
```

**Perché:** aggiunge contesto biologico (posizione su feature annotate) e verifica se la copertura del gene mock è sufficiente per fidarsi del risultato.

---

## Output minimi attesi (per ogni caso)
In `results/<case>/` dovresti avere almeno:
- report FastQC,
- BAM ordinato + indice,
- `flagstat.txt` e `depth.tsv`,
- `raw.vcf`, `final_lenient.vcf`, `final_strict.vcf`,
- file di annotazione/copertura (`final_lenient.annotated.vcf`, `mock_gene_coverage.tsv`).
