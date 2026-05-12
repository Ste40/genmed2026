# SOLUZIONI ISTRUTTORE — FILE LOCALE

Copia questo file in locale (esempio: `private_instructor/lezione1/SOLUZIONI_ISTRUTTORE.md`) e non committarlo.

## Esercizio 1 — Esplorazione file `.txt`
```bash
cd Lezioni/lezione1_pratica_bash/materiali
ls
cat appunti_lezione.txt
head -n 5 frasi_cliniche.txt
tail -n 3 referto_mock.txt
```

## Esercizio 2 — Conteggi e output
```bash
wc -l frasi_cliniche.txt > ../output_es2.txt
wc -m referto_mock.txt >> ../output_es2.txt
echo "Controllo completato" >> ../output_es2.txt
```

## Esercizio 3 — Ricerca parole con `grep`
```bash
grep "paziente" frasi_cliniche.txt
grep -i "terapia" frasi_cliniche.txt
grep "paziente" frasi_cliniche.txt > ../paziente_hits.txt
```

## Esercizio 4 — Sostituzione testo con `sed`
```bash
sed 's/stabile/monitorato/g' referto_mock.txt > ../referto_editato.txt
grep "monitorato" ../referto_editato.txt
```

## Esercizio 5 — Script già pronto
Lo script è già presente ed eseguibile in:
`Lezioni/lezione1_pratica_bash/materiali/sostituisci_parola.sh`

Uso:
```bash
./sostituisci_parola.sh <input_file> <parola_vecchia> <parola_nuova> <output_file>
```

Esempio:
```bash
cd Lezioni/lezione1_pratica_bash/materiali
./sostituisci_parola.sh frasi_cliniche.txt paziente soggetto ../output_sostituito.txt
```
