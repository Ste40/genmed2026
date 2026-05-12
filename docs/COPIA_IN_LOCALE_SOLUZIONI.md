# File da copiare in locale (NON committare)

Copia tutto il blocco qui sotto in un file locale, ad esempio:
`private_instructor/lezione1/SOLUZIONI_ISTRUTTORE.md`

---

```md
# Soluzioni istruttore — Lezione 1

> File locale docente. NON committare.

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

## Esercizio 5 — Mini script `.sh`

```bash
cat > ../sostituisci_parola.sh << 'SH'
#!/usr/bin/env bash
input_file="$1"
parola_vecchia="$2"
parola_nuova="$3"
output_file="$4"

sed "s/${parola_vecchia}/${parola_nuova}/g" "$input_file" > "$output_file"
echo "File creato: $output_file"
SH

chmod +x ../sostituisci_parola.sh
../sostituisci_parola.sh frasi_cliniche.txt paziente soggetto ../output_sostituito.txt
```
```
