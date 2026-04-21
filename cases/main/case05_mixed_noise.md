# Caso 5 — Qualità mista, Ns e hard filtering ragionato

**Input:** `data/dataset5/sample5.fastq`

## Obiettivo didattico
Combinare pre-processing FASTQ e filtri VCF per ripulire un campione eterogeneo.

## Step operativi
```bash
CASE=case05
FASTQ=data/dataset5/sample5.fastq
REF=data/reference/mock_reference.fa
OUT=results/$CASE
mkdir -p $OUT

fastqc -o $OUT $FASTQ

# Rimozione reads corte e con troppe N (>=10)
python - <<'PY'
from pathlib import Path
inp='data/dataset5/sample5.fastq'
out='results/case05/sample5.cleaned.fastq'
Path('results/case05').mkdir(parents=True, exist_ok=True)
with open(inp) as f, open(out,'w') as o:
    while True:
        h=f.readline();
        if not h: break
        s=f.readline().strip(); p=f.readline(); q=f.readline().strip()
        if len(s) < 70: continue
        if s.count('N') >= 10: continue
        o.write(h); o.write(s+'\n'); o.write('+\n'); o.write(q+'\n')
PY

bwa mem $REF $OUT/sample5.cleaned.fastq | samtools sort -o $OUT/aln.sorted.bam
samtools index $OUT/aln.sorted.bam

bcftools mpileup -f $REF $OUT/aln.sorted.bam -Ou |
  bcftools call -mv -Ov -o $OUT/raw.vcf
bcftools filter -i 'QUAL>=30 && DP>=10' $OUT/raw.vcf -Ov -o $OUT/final.vcf
```

## Checklist interpretativa
- Dimostrare che il cleaning riduce rumore senza eliminare il segnale reale.
- Riportare quante reads sono state rimosse e perché.
- Verificare corrispondenza della variante finale con la tabella causativa.
