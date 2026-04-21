# Caso 9 (riserva) — Alto contenuto di N e code low-complexity

**Input:** `data/dataset9/sample9.fastq`

## Scenario
Molte reads contengono blocchi di N e alcune code artificiali, con impatto sul mapping.

## Step operativi
```bash
CASE=case09
FASTQ=data/dataset9/sample9.fastq
REF=data/reference/mock_reference.fa
OUT=results/$CASE
mkdir -p $OUT

fastqc -o $OUT $FASTQ

# filtro: massimo 8 N per read + lunghezza minima 70
python - <<'PY'
from pathlib import Path
inp='data/dataset9/sample9.fastq'
out='results/case09/sample9.filtered.fastq'
Path('results/case09').mkdir(parents=True, exist_ok=True)
with open(inp) as f, open(out,'w') as o:
    while True:
        h=f.readline()
        if not h: break
        s=f.readline().strip(); p=f.readline(); q=f.readline().strip()
        if len(s) < 70: continue
        if s.count('N') > 8: continue
        o.write(h); o.write(s+'\n'); o.write('+\n'); o.write(q+'\n')
PY

bwa mem $REF $OUT/sample9.filtered.fastq | samtools sort -o $OUT/aln.sorted.bam
samtools index $OUT/aln.sorted.bam

bcftools mpileup -f $REF $OUT/aln.sorted.bam -Ou |
  bcftools call -mv -Ov -o $OUT/final.vcf
```

## Discussione
- Confrontare rate di mapping prima/dopo filtraggio.
- Valutare se la rimozione di reads problematiche migliora la specificità.
