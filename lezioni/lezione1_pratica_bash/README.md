# Lezione 1 — Esercitazione Bash (base)

Questa esercitazione usa file `.txt` creati nella cartella della lezione.

Durata totale prevista: **60–75 minuti**.

## Materiali

File disponibili in `lezioni/lezione1_pratica_bash/materiali/`:

- `sequenza1.txt`
- `referto_mock.txt`
- `appunti_lezione.txt`
- `frasi_cliniche.txt`

---

## Uso dei comandi (senza soluzione)

- `ls`
  - Uso: `ls`
  - Uso: `ls -l`
  - Uso: `ls <cartella>`
- `cat`
  - Uso: `cat <file>`
- `head`
  - Uso: `head <file>`
  - Uso: `head -n <numero_righe> <file>`
- `tail`
  - Uso: `tail <file>`
  - Uso: `tail -n <numero_righe> <file>`
- `less`
  - Uso: `less <file>` (uscita con `q`)
- `echo`
  - Uso: `echo "testo"`
- `grep`
  - Uso: `grep "parola" <file>`
  - Uso: `grep -i "parola" <file>`
- `sed`
  - Uso: `sed 's/testo_vecchio/testo_nuovo/' <file>`
  - Uso: `sed 's/testo_vecchio/testo_nuovo/g' <file>`
- `wc`
  - Uso: `wc -m <file>` (caratteri)
  - Uso: `wc -l <file>` (righe)
- Redirect
  - Uso: `comando > <file_output>`
  - Uso: `comando >> <file_output>`
- Pipe
  - Uso: `comando1 | comando2`

---

## Esercizio 1 — Orientamento e lettura file (10–12 min)

### Task
1. Entrare nella root della repo.
2. Elencare il contenuto della cartella `lezioni/lezione1_pratica_bash/materiali`.
3. Visualizzare il contenuto completo di `referto_mock.txt`.
4. Mostrare solo le prime 3 righe del referto.
5. Mostrare solo le ultime 2 righe del referto.
6. Aprire il referto con `less` e scorrere il testo.

---

## Esercizio 2 — Conteggi su testo e sequenze (12–15 min)

### Task
1. Calcolare quanti caratteri contiene `sequenza1.txt`.
2. Calcolare quante righe contiene `sequenza1.txt`.
3. Ripetere i due conteggi per `appunti_lezione.txt`.
4. Salvare i risultati in `lezioni/lezione1_pratica_bash/output/conteggi.txt`.
5. Aggiungere una riga finale nel file di output con data e ora tramite `echo`.

---

## Esercizio 3 — Ricerca pattern biologici/testuali (12–15 min)

### Task
1. Cercare la parola `variante` in `referto_mock.txt`.
2. Cercare in modo case-insensitive la parola `oncologia` in `referto_mock.txt`.
3. Cercare la parola `sospetta` in `frasi_cliniche.txt`.
4. Salvare solo le righe trovate al punto 3 in `output/righe_sospette.txt`.
5. Visualizzare il file ottenuto con `cat` e con `less`.

---

## Esercizio 4 — Sostituzione testo e verifica (15 min)

### Task
1. Usare `sed` per sostituire nel file `frasi_cliniche.txt` la parola `sospetta` con `patogena`.
2. Salvare il risultato in `output/frasi_modificate.txt`.
3. Verificare con `grep` che nel nuovo file compaia `patogena`.
4. Verificare con `grep` che nel nuovo file non compaia più `sospetta`.
5. Aggiungere una nota di due righe in `output/log_esercizio4.txt` usando `>` e `>>`.

---

## Esercizio 5 — Script `.sh` da creare in Binder (20 min)

### Obiettivo
Creare uno script Bash che:
- legga una frase da file,
- trovi una parola specifica,
- sostituisca la parola,
- stampi la frase aggiornata a terminale.

### Vincoli
- Non usare editor grafici.
- Creare il file script direttamente da terminale (es. redirect/here-doc).

### Task
1. Creare il file `lezioni/lezione1_pratica_bash/sostituisci.sh` da terminale.
2. Inserire nello script i seguenti passaggi logici:
   - definizione di una variabile con frase iniziale;
   - ricerca della parola target;
   - sostituzione della parola con una nuova;
   - stampa della frase aggiornata a terminale.
3. Rendere eseguibile lo script.
4. Eseguire lo script da terminale.
5. Salvare l'output dello script in `output/output_script.txt`.

### Usage utile per questo esercizio
- Creazione file da terminale:
  - `cat > nome_file <<'EOF'`
  - `...contenuto...`
  - `EOF`
- Permessi esecuzione:
  - `chmod +x nome_file.sh`
- Esecuzione script:
  - `./nome_file.sh`
- Salvataggio output script:
  - `./nome_file.sh > output.txt`

---

## Consegna consigliata

Al termine, verificare che esistano nella cartella `lezioni/lezione1_pratica_bash/output/` almeno:

- `conteggi.txt`
- `righe_sospette.txt`
- `frasi_modificate.txt`
- `log_esercizio4.txt`
- `output_script.txt`
