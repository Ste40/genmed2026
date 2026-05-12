# Soluzioni istruttore — Lezione 1 pratica Bash

## Esercizio 1
```bash
cd /workspace/genmed2026
ls Lezioni/lezione1_pratica_bash/materiali
cat Lezioni/lezione1_pratica_bash/materiali/appunti_lezione.txt
head -n 5 Lezioni/lezione1_pratica_bash/materiali/frasi_cliniche.txt
tail -n 3 Lezioni/lezione1_pratica_bash/materiali/referto_mock.txt
```

## Esercizio 2
```bash
wc -l Lezioni/lezione1_pratica_bash/materiali/frasi_cliniche.txt
wc -m Lezioni/lezione1_pratica_bash/materiali/referto_mock.txt
wc -l Lezioni/lezione1_pratica_bash/materiali/frasi_cliniche.txt > Lezioni/lezione1_pratica_bash/output_es2.txt
wc -m Lezioni/lezione1_pratica_bash/materiali/referto_mock.txt >> Lezioni/lezione1_pratica_bash/output_es2.txt
echo "Controllo completato" >> Lezioni/lezione1_pratica_bash/output_es2.txt
```

## Esercizio 3
```bash
grep "paziente" Lezioni/lezione1_pratica_bash/materiali/frasi_cliniche.txt
grep -i "terapia" Lezioni/lezione1_pratica_bash/materiali/frasi_cliniche.txt
grep "paziente" Lezioni/lezione1_pratica_bash/materiali/frasi_cliniche.txt > Lezioni/lezione1_pratica_bash/paziente_hits.txt
```

## Esercizio 4
```bash
sed 's/stabile/monitorato/g' Lezioni/lezione1_pratica_bash/materiali/referto_mock.txt > Lezioni/lezione1_pratica_bash/referto_editato.txt
grep "monitorato" Lezioni/lezione1_pratica_bash/referto_editato.txt
```

## Esercizio 5
### Script
```bash
#!/usr/bin/env bash
INPUT_FILE="$1"
DA_CERCARE="$2"
SOSTITUZIONE="$3"
OUTPUT_FILE="$4"

sed "s/${DA_CERCARE}/${SOSTITUZIONE}/g" "$INPUT_FILE" > "$OUTPUT_FILE"
echo "File creato: $OUTPUT_FILE"
```

### Esecuzione
```bash
chmod +x Lezioni/lezione1_pratica_bash/sostituisci_parola.sh
Lezioni/lezione1_pratica_bash/sostituisci_parola.sh \
  Lezioni/lezione1_pratica_bash/materiali/frasi_cliniche.txt \
  paziente soggetto \
  Lezioni/lezione1_pratica_bash/output_sostituito.txt
```
