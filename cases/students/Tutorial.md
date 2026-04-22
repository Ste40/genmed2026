````markdown
# Guida unica studenti (valida per tutti i casi)

Questa guida sostituisce le istruzioni duplicate per ogni case e descrive un workflow completo, didattico e riproducibile da FASTQ a VCF.

## Quando usare questa guida
Usala per **qualsiasi dataset assegnato** (`dataset1` ... `dataset10`), cambiando solo le variabili iniziali.

---

## 1) Setup generale
Imposta il numero del caso e il FASTQ assegnato.

```bash
# Esegui i comandi dalla root del repository
cd $HOME

CASE=case01
FASTQ=data/dataset1/sample1.fastq
REF=data/reference/mock_reference.fa
OUT=results/$CASE
mkdir -p "$OUT/fastqc"
````

> Per gli altri casi cambia solo `CASE` e `FASTQ` (es. `case07` + `data/dataset7/sample7.fastq`).

---

## 2) Quality control iniziale: eseguiamo FastQC sul nostro file

```bash
fastqc -o "$OUT/fastqc" "$FASTQ"
```

Apri il report HTML (`$OUT/fastqc/*_fastqc.html`) e interpreta:

* qualità per base,
* distribuzione lunghezze,
* contenuto GC,
* sequenze sovra-rappresentate.

**Razionale bioinformatico**
Il controllo qualità iniziale serve a capire se il dato grezzo presenta problemi che possono influenzare le fasi successive, come basi terminali di bassa qualità, contaminazioni o distribuzioni anomale delle reads. Questo passaggio permette di decidere se intervenire sul file oppure mantenerlo invariato, evitando modifiche inutili o arbitrarie.

---

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

**Razionale bioinformatico**
La pulizia dei dati serve a rimuovere reads o porzioni di reads poco affidabili che potrebbero causare allineamenti errati o falsi positivi nel variant calling. Il trimming di qualità riduce l’impatto di errori nelle estremità delle reads, mentre il filtro di lunghezza elimina sequenze troppo corte e quindi spesso ambigue. Va fatto solo se il QC lo giustifica.

---

## 4) Allineamento e preparazione BAM

```bash
INPUT_FOR_ALIGNMENT=${OUT}/clean.fastq
[ -s "$INPUT_FOR_ALIGNMENT" ] || { echo "Errore: manca $INPUT_FOR_ALIGNMENT. Esegui prima lo step 3."; exit 1; }

bwa index $REF
samtools faidx $REF
bwa mem $REF $INPUT_FOR_ALIGNMENT | samtools sort -o $OUT/aln.sorted.bam
samtools index $OUT/aln.sorted.bam
samtools flagstat $OUT/aln.sorted.bam > $OUT/flagstat.txt
samtools depth $OUT/aln.sorted.bam > $OUT/depth.tsv
```

**Razionale bioinformatico**
L’allineamento serve a posizionare ogni read sul genoma di riferimento per ricostruire dove si trovano le basi osservate nel campione. Il BAM ordinato e indicizzato è il formato standard per tutte le analisi successive. I file `flagstat` e `depth` aiutano a interpretare la qualità globale dell’allineamento e la copertura per locus, due elementi fondamentali per giudicare l’affidabilità delle varianti chiamate.

---

## 5) Variant calling

```bash
bcftools mpileup -f $REF $OUT/aln.sorted.bam -Ou | \
  bcftools call -mv -Ov -o $OUT/raw.vcf
```

**Razionale bioinformatico**
Questo passaggio trasforma l’evidenza osservata nei reads allineati in un elenco di possibili varianti rispetto al riferimento. `mpileup` costruisce il quadro delle basi osservate a ogni posizione, mentre `call` identifica i siti che mostrano supporto per un allele alternativo. Il file `raw.vcf` rappresenta l’insieme iniziale delle chiamate, prima del filtraggio.

---

## 6) Filtraggio varianti: confronto lenient vs strict

```bash
bcftools filter -i 'QUAL>=20 && DP>=6'  $OUT/raw.vcf -Ov -o $OUT/final_lenient.vcf
bcftools filter -i 'QUAL>=30 && DP>=10' $OUT/raw.vcf -Ov -o $OUT/final_strict.vcf
```

**Razionale bioinformatico**
Il filtraggio serve a separare le varianti meglio supportate da quelle più deboli o potenzialmente artefattuali. Confrontare una soglia più permissiva e una più severa aiuta a capire il compromesso tra sensibilità e specificità: filtri più morbidi mantengono più varianti candidate, mentre filtri più stringenti aumentano la fiducia ma possono perdere segnali reali a copertura più bassa.

---

## 7) Interpretazione finale

```bash
bcftools view -H $OUT/final_lenient.vcf
bcftools view -H $OUT/final_strict.vcf
```

**Razionale bioinformatico**
Leggere direttamente i record del VCF permette di verificare quali varianti sono rimaste dopo il filtraggio e di confrontare posizione, allele alternativo, profondità e qualità. Questo step è importante perché aiuta a non trattare il file finale come una black box, ma come un risultato da interpretare criticamente.

---

## 8) Extra: annotazione su gene mock e copertura

```bash
ANNOT=data/reference/mock_annotation.gff

bedtools intersect -header -wa -a $OUT/final_lenient.vcf -b $ANNOT > $OUT/final_lenient.annotated.vcf
bedtools coverage -a $ANNOT -b $OUT/aln.sorted.bam -mean > $OUT/mock_gene_coverage.tsv
sort -k10,10n $OUT/mock_gene_coverage.tsv | head
```

**Razionale bioinformatico**
Questo step aggiunge contesto biologico alle varianti chiamate. L’intersezione con il file GFF permette di capire se una variante cade in una feature annotata, mentre il calcolo della copertura media sulle regioni annotate aiuta a valutare quanto sia solido il supporto sperimentale in quei geni o intervalli. In questo modo la variante non viene considerata solo come differenza rispetto al riferimento, ma anche nel suo possibile contesto funzionale.

---

## 9) Visualizzazione manuale in IGV (consigliato)

Per validare visivamente la variante candidata, apri i file in **IGV (Integrative Genomics Viewer)**.

### 9.0 Come aprire IGV (nota importante su questo ambiente)

Nel nostro ambiente didattico Jupyter/Binder **non è previsto un comando shell `igv`**.
Inoltre `igv_notebook` è una libreria Python: non la usi scrivendo `igv` dentro il prompt `>>>`.

### 9.1 Preparazione file

Assicurati di avere:

* riferimento: `data/reference/mock_reference.fa` + indice `data/reference/mock_reference.fa.fai`
* BAM ordinato + indice: `results/<case>/aln.sorted.bam` e `results/<case>/aln.sorted.bam.bai`
* VCF filtrato: `results/<case>/final_lenient.vcf` oppure `results/<case>/final_strict.vcf`

Se manca l'indice FASTA, crealo una volta:

```bash
samtools faidx data/reference/mock_reference.fa
```

### 9.2 Avviamo IGV

Se lavori in Jupyter/Binder, puoi inizializzare IGV direttamente in notebook caricando riferimento + BAM + VCF + annotazioni in un'unica configurazione.

```python
import igv_notebook
igv_notebook.init()

CASE = "case01"

b = igv_notebook.Browser({
    "reference": {
        "id": "mock_ref",
        "name": "Mock reference",
        "fastaURL": "../../data/reference/mock_reference.fa",
        "indexURL": "../../data/reference/mock_reference.fa.fai"
    },
    "locus": "mock_chromosome:50-150",
    "tracks": [
        {
            "name": f"{CASE} BAM",
            "url": f"../../results/{CASE}/aln.sorted.bam",
            "indexURL": f"../../results/{CASE}/aln.sorted.bam.bai",
            "format": "bam",
            "type": "alignment"
        },
        {
            "name": f"{CASE} final lenient VCF",
            "url": f"../../results/{CASE}/final_lenient.vcf",
            "format": "vcf",
            "type": "variant",
            "displayMode": "EXPANDED"
        },
        {
            "name": "Mock annotation",
            "url": "../../data/reference/mock_annotation.gff",
            "format": "gff",
            "type": "annotation",
            "displayMode": "EXPANDED",
            "height": 120
        }
    ]
})

b
```

**Razionale bioinformatico**
La visualizzazione in IGV serve come controllo finale di plausibilità. Permette di osservare direttamente se la variante è supportata da più reads, se la copertura è sufficiente e se il pattern osservato è compatibile con una vera variante o con un possibile artefatto tecnico. È un passaggio utile per collegare i risultati computazionali alla loro evidenza sperimentale reale.

### 9.3 Cosa controllare al locus variante

Vai alla posizione della variante (colonna `CHROM:POS` nel VCF), poi verifica:

* copertura sufficiente,
* presenza coerente dell'allele alternativo in più reads,
* qualità di mapping/read plausibile,
* assenza di bias evidente.

---

## Output minimi attesi (per ogni caso)

In `results/<case>/` dovresti avere almeno:

* report FastQC,
* BAM ordinato + indice,
* `flagstat.txt` e `depth.tsv`,
* `raw.vcf`, `final_lenient.vcf`, `final_strict.vcf`,
* file di annotazione/copertura (`final_lenient.annotated.vcf`, `mock_gene_coverage.tsv`).

```
```
