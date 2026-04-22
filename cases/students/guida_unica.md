# Guida unica studenti (valida per tutti i casi)

Questa guida sostituisce le istruzioni duplicate per ogni case e descrive un workflow completo, didattico e riproducibile da FASTQ a VCF.

## Quando usare questa guida
Usala per **qualsiasi dataset assegnato** (`dataset1` ... `dataset10`), cambiando solo le variabili iniziali.

---

## 1) Setup generale
Imposta il numero del caso e il FASTQ assegnato.

```bash
# Esegui i comandi dalla root del repository

CASE=case01
FASTQ=data/dataset1/sample1.fastq
REF=data/reference/mock_reference.fa
OUT=results/$CASE
mkdir -p "$OUT/fastqc"
if [ ! -r "$FASTQ" ]; then
  echo "Errore: FASTQ non trovato: $FASTQ"
  echo "Controlla di essere in /workspace/genmed2026 e verifica con: ls data"
  echo "Struttura attesa: binder  cases  data  GUIDA_TOOLS.md  README.md  results  work"
fi
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
samtools faidx $REF
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

## 9) Visualizzazione manuale in IGV (consigliato)
Per validare visivamente la variante candidata, apri i file in **IGV (Integrative Genomics Viewer)**.

### 9.0 Come aprire IGV (nota importante su questo ambiente)
Nel nostro ambiente didattico Jupyter/Binder **non è previsto un comando shell `igv`**.
Inoltre `igv-notebook` è una libreria Python: non la usi scrivendo `igv` dentro il prompt `>>>`.

Usa questo schema pratico:

1. **Da terminale (non dentro `>>>`) verifica/installa il pacchetto:**
   ```bash
   python -c "import igv_notebook; print('igv_notebook OK')"
   # se fallisce:
   pip install igv-notebook
   ```
2. **Riavvia il kernel del notebook** (se hai appena installato).
3. **In una cella Jupyter (non nel terminale `python`)** esegui:
   ```python
   import igv_notebook
   igv_notebook.init()
   ```
4. **Nella cella successiva** crea e visualizza il browser IGV (vedi esempio completo in `GUIDA_TOOLS.md`).

Se vedi errori tipo `NameError: name 'igv' is not defined`, significa che stai digitando `igv` nel prompt Python: non è il comando corretto in quel contesto.

Se vedi `AttributeError: 'NoneType' object has no attribute 'kernel'` durante `igv_notebook.init()`, significa che hai lanciato il codice **fuori da un kernel Jupyter attivo** (ad esempio nel REPL `python` da terminale). In quel caso:
- esci dal REPL (`exit()`),
- apri un notebook in JupyterLab,
- riesegui `import igv_notebook` + `igv_notebook.init()` dentro una cella.

Per **Desktop locale** (fuori da Binder/Jupyter), avvia IGV dalla GUI oppure con lo script dell'installazione (`igv.sh` su Linux/macOS, `igv.bat` su Windows).

### 9.1 Preparazione file
Assicurati di avere:
- riferimento: `data/reference/mock_reference.fa` + indice `data/reference/mock_reference.fa.fai`
- BAM ordinato + indice: `results/<case>/aln.sorted.bam` e `results/<case>/aln.sorted.bam.bai`
- VCF filtrato (consigliato): `results/<case>/final_lenient.vcf` oppure `results/<case>/final_strict.vcf`

Se manca l'indice FASTA, crealo una volta:
```bash
samtools faidx data/reference/mock_reference.fa
```

Se vuoi, puoi comprimere e indicizzare il VCF per una navigazione più rapida:
```bash
bgzip -c $OUT/final_lenient.vcf > $OUT/final_lenient.vcf.gz
tabix -p vcf $OUT/final_lenient.vcf.gz
```

### 9.2 Caricamento in IGV
1. Apri IGV.
2. Seleziona il genoma di riferimento locale:
   - **Genomes → Load Genome from File...**
   - scegli `data/reference/mock_reference.fa`.
3. Carica i track:
   - **File → Load from File...**
   - seleziona `aln.sorted.bam` (IGV userà automaticamente il `.bai`)
   - seleziona il VCF (`.vcf` o `.vcf.gz`).

### 9.3 Cosa controllare al locus variante
Vai alla posizione della variante (colonna `CHROM:POS` nel VCF), poi verifica:
- copertura sufficiente (pileup non troppo scarso),
- presenza coerente dell'allele alternativo in più reads,
- qualità di mapping/read plausibile (assenza di pattern fortemente sospetti),
- assenza di bias evidente (solo estremità read o solo un orientamento).

### 9.4 Cosa riportare nel tuo elaborato
Per ogni variante finale candidata, aggiungi una breve nota:
- posizione (`CHROM:POS`),
- quota approssimativa di reads con allele alternativo osservata in IGV,
- eventuali elementi che aumentano/riducono la fiducia (copertura bassa, mismatch multipli, ecc.).

**Perché:** il controllo visivo in IGV aiuta a distinguere varianti plausibili da possibili artefatti tecnici non evidenti con i soli filtri automatici.

### 9.5 Esempio pratico `igv_notebook` adattato a questo corso
Se lavori in Jupyter/Binder, puoi inizializzare IGV direttamente in notebook caricando riferimento + BAM + VCF + annotazioni in un'unica configurazione.

```python
import igv_notebook
igv_notebook.init()

CASE = "case01"  # cambia con il tuo case (es. case07)

b = igv_notebook.Browser({
    "reference": {
        "id": "mock_ref",
        "name": "Mock reference",
        "fastaURL": "data/reference/mock_reference.fa",
        "indexURL": "data/reference/mock_reference.fa.fai"
    },
    "locus": "chr1:1-1000",  # opzionale: puoi cambiare con CHROM:POS del tuo VCF
    "tracks": [
        {
            "name": f"{CASE} BAM",
            "url": f"results/{CASE}/aln.sorted.bam",
            "indexURL": f"results/{CASE}/aln.sorted.bam.bai",
            "format": "bam",
            "type": "alignment"
        },
        {
            "name": f"{CASE} VCF lenient",
            "url": f"results/{CASE}/final_lenient.vcf.gz",
            "indexURL": f"results/{CASE}/final_lenient.vcf.gz.tbi",
            "format": "vcf",
            "type": "variant",
            "displayMode": "EXPANDED"
        },
        {
            "name": "Mock annotation",
            "url": "data/reference/mock_annotation.gff",
            "format": "gff",
            "type": "annotation",
            "displayMode": "EXPANDED",
            "height": 120
        }
    ]
})

b
```

Note operative importanti:
- Se usi `final_lenient.vcf.gz`, crea prima indice tabix con `tabix -p vcf` (vedi step 9.1).
- Nel blocco `Browser({...})` sopra il riferimento custom usa `indexURL`: quindi serve il `.fai` (`samtools faidx data/reference/mock_reference.fa`).
- Se non hai compresso il VCF, puoi usare anche `results/<case>/final_lenient.vcf` senza `indexURL` (meno fluido su file grandi).

---

## Output minimi attesi (per ogni caso)
In `results/<case>/` dovresti avere almeno:
- report FastQC,
- BAM ordinato + indice,
- `flagstat.txt` e `depth.tsv`,
- `raw.vcf`, `final_lenient.vcf`, `final_strict.vcf`,
- file di annotazione/copertura (`final_lenient.annotated.vcf`, `mock_gene_coverage.tsv`).
