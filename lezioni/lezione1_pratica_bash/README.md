# Lezione 1 — Esercitazione pratica Bash (base)

Questa esercitazione è pensata per specializzandi biologi/medici con poca esperienza di terminale.

## Obiettivo

Lavorare su **file già presenti nella repository** e imparare operazioni base:

- visualizzare contenuti;
- contare caratteri/righe;
- cercare parole o pattern;
- sostituire testo;
- salvare output con redirect e pipe.

Durata totale: **60–75 minuti**.

---

## File usati (già precaricati)

- `data/reference/mock_reference.fa`
- `data/reference/mock_annotation.gff`
- `data/reference/causative_variants.tsv`

---

## Usage rapido comandi

- `ls` → elenca file/cartelle
  - Uso: `ls`, `ls -l`, `ls data/reference`
- `cat` → mostra contenuto completo
  - Uso: `cat FILE`
- `head` / `tail` → prime/ultime righe
  - Uso: `head -n 5 FILE`, `tail -n 5 FILE`
- `less` → visualizzazione scorrevole (`q` per uscire)
  - Uso: `less FILE`
- `echo` → stampa testo
  - Uso: `echo "testo"`
- `grep` → cerca stringhe/pattern
  - Uso: `grep "pattern" FILE`
- `sed` → sostituisce testo
  - Uso: `sed 's/vecchio/nuovo/g' FILE`
- `wc` → conta (righe/parole/caratteri)
  - Uso: `wc -m FILE` (caratteri), `wc -l FILE` (righe)
- `>` e `>>` → scrivi/aggiungi su file
  - Uso: `comando > out.txt`, `comando >> out.txt`
- `|` → collega più comandi
  - Uso: `comando1 | comando2`

---

## Esercizio 1 (facile) — Visualizzare un file FASTA
**Tempo:** 10 minuti

### Task step-by-step
1. Vai nella root della repo.
2. Elenca il contenuto di `data/reference`.
3. Visualizza tutto `mock_reference.fa`.
4. Mostra solo le prime 6 righe.
5. Mostra solo le ultime 4 righe.

### Comandi esempio
```bash
cd /workspace/genmed2026
ls data/reference
cat data/reference/mock_reference.fa
head -n 6 data/reference/mock_reference.fa
tail -n 4 data/reference/mock_reference.fa
```

---

## Esercizio 2 (facile-intermedio) — Contare caratteri e righe
**Tempo:** 10–12 minuti

### Task step-by-step
1. Conta quanti caratteri ha `mock_reference.fa`.
2. Conta quante righe ha `mock_reference.fa`.
3. Salva i risultati in `lezioni/lezione1_pratica_bash/output_es2.txt`.
4. Aggiungi una riga di commento al file di output.

### Comandi esempio
```bash
mkdir -p lezioni/lezione1_pratica_bash
wc -m data/reference/mock_reference.fa
wc -l data/reference/mock_reference.fa
wc -m data/reference/mock_reference.fa > lezioni/lezione1_pratica_bash/output_es2.txt
wc -l data/reference/mock_reference.fa >> lezioni/lezione1_pratica_bash/output_es2.txt
echo "Controllo base completato su mock_reference.fa" >> lezioni/lezione1_pratica_bash/output_es2.txt
cat lezioni/lezione1_pratica_bash/output_es2.txt
```

---

## Esercizio 3 (intermedio) — Trovare una parola/pattern
**Tempo:** 12–15 minuti

### Task step-by-step
1. Cerca nel file `causative_variants.tsv` tutte le righe che contengono `gene2`.
2. Cerca tutte le righe che contengono `chr`.
3. Salva solo le righe con `gene2` in un file dedicato.
4. Apri il file salvato con `less`.

### Comandi esempio
```bash
grep "gene2" data/reference/causative_variants.tsv
grep "chr" data/reference/causative_variants.tsv
grep "gene2" data/reference/causative_variants.tsv > lezioni/lezione1_pratica_bash/varianti_gene2.tsv
less lezioni/lezione1_pratica_bash/varianti_gene2.tsv
```

---

## Esercizio 4 (intermedio) — Sostituire testo (Y → Z)
**Tempo:** 12–15 minuti

### Task step-by-step
1. Prendi `mock_annotation.gff`.
2. Sostituisci il testo `gene` con `GENE`.
3. Salva il risultato in `annotation_edit.gff`.
4. Verifica che `GENE` compaia nel nuovo file.

### Comandi esempio
```bash
sed 's/gene/GENE/g' data/reference/mock_annotation.gff > lezioni/lezione1_pratica_bash/annotation_edit.gff
grep "GENE" lezioni/lezione1_pratica_bash/annotation_edit.gff
head -n 10 lezioni/lezione1_pratica_bash/annotation_edit.gff
```

---

## Esercizio 5 (intermedio-avanzato base) — Pipeline con `|`
**Tempo:** 15–20 minuti

### Task step-by-step
1. Cerca in `causative_variants.tsv` le righe che contengono `gene2`.
2. Delle righe trovate, tieni solo quelle con `sospetto`.
3. Salva il risultato in `gene2_sospetto.tsv`.
4. Mostra quante righe ci sono nel risultato finale.

### Comandi esempio
```bash
grep "gene2" data/reference/causative_variants.tsv | grep -i "sospetto"
grep "gene2" data/reference/causative_variants.tsv | grep -i "sospetto" > lezioni/lezione1_pratica_bash/gene2_sospetto.tsv
wc -l lezioni/lezione1_pratica_bash/gene2_sospetto.tsv
cat lezioni/lezione1_pratica_bash/gene2_sospetto.tsv
```

---

## Debrief finale (5 minuti)

A fine esercitazione lo studente deve sapere:

1. aprire e leggere rapidamente file biologici semplici;
2. contare caratteri/righe;
3. cercare pattern con `grep`;
4. fare sostituzioni base con `sed`;
5. combinare filtri con pipe `|` e salvare risultati con `>`/`>>`.
