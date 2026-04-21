# Caso 9

**Dataset assegnato:** `data/dataset9/sample9.fastq`

Per l'intero workflow (QC → cleaning opzionale → allineamento → variant calling → filtraggio → interpretazione), usa la guida unica:

- [Guida unica studenti](../guida_unica.md)  
  (se sei nella cartella `main/` o `reserve/`, il link relativo è corretto)

## Setup rapido per questo caso
```bash
# Spostati automaticamente alla root del repository (da qualunque sottocartella)
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "Errore: esegui i comandi dentro la repo."; exit 1; }
cd "$REPO_ROOT"

CASE=case09
FASTQ=data/dataset9/sample9.fastq
REF=data/reference/mock_reference.fa
OUT=results/$CASE
mkdir -p "$OUT/fastqc"
[ -r "$FASTQ" ] || { echo "Errore: FASTQ non trovato: $FASTQ"; exit 1; }
```
