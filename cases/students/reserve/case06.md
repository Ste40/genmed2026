# Caso 6

**Dataset assegnato:** `data/dataset6/sample6.fastq`

Per l'intero workflow (QC -> cleaning opzionale -> allineamento -> variant calling -> filtraggio -> interpretazione), usa la guida unica:

- [Guida unica studenti](../guida_unica.md)  
  (se sei nella cartella `main/` o `reserve/`, il link relativo e' corretto)

## Setup rapido per questo caso

```bash
# Esegui i comandi dalla root del repository
cd $HOME

CASE=case06
FASTQ=data/dataset6/sample6.fastq
REF=data/reference/mock_reference.fa
OUT=results/$CASE
mkdir -p "$OUT/fastqc"
if [ ! -r "$FASTQ" ]; then
  echo "Errore: FASTQ non trovato: $FASTQ"
  echo "Controlla di essere in /workspace/genmed2026 e verifica con: ls data"
  echo "Struttura attesa: binder  cases  data  GUIDA_TOOLS.md  README.md  results  work"
fi
```


Dopo il setup, esegui tutti i passaggi dalla **Guida unica studenti**: QC, allineamento, variant calling e interpretazione.
