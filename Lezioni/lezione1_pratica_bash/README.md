# Lezione 1 — Esercitazione pratica Bash (base)


## Obiettivo

Lavorare su **file di testo `.txt` preparati appositamente** per la lezione 1 e imparare operazioni base:

- visualizzare contenuti;
- contare caratteri e righe;
- cercare parole o pattern;
- sostituire testo;
- salvare output con reindirizzamento e pipe;
- creare un piccolo script `.sh`.

Durata totale: **circa 60 minuti**.

---

## File usati (specifici della lezione 1)

Tutti i file sono in `Lezioni/lezione1_pratica_bash/materiali/`:

- `appunti_lezione.txt`
- `frasi_cliniche.txt`
- `referto_mock.txt`
- `sequenza1.txt`

---

## Legenda dei comandi comandi

- `ls` → elenca file/cartelle
- `cat` → mostra contenuto completo
- `head` / `tail` → prime/ultime righe
- `less` → visualizzazione scorrevole (`q` per uscire)
- `grep` → cerca stringhe/pattern
- `wc` → conta righe/parole/caratteri
- `sed` → sostituisce testo
- `>` e `>>` → scrivi/aggiungi su file
- `|` → collega più comandi
- `chmod +x` → rende eseguibile uno script

Suggerimento generale: per ogni comando usa l'helper integrato (`--help`) per vedere opzioni e sintassi disponibili (es. `grep --help`, `sed --help`, `wc --help`).

---

## Esercizio 1 (facile) — Esplorazione file `.txt`

1. Vai nella root della repo.
2. Elenca il contenuto di `Lezioni/lezione1_pratica_bash/materiali`.
3. Visualizza tutto `appunti_lezione.txt`.
4. Mostra le prime 5 righe di `frasi_cliniche.txt`.
5. Mostra le ultime 3 righe di `referto_mock.txt`.

### Come impostare i comandi
- Usa un comando per spostarti nella cartella corretta.
- Usa un comando per elencare i file di una directory specifica.
- Usa un comando per visualizzare l'intero contenuto di un file `.txt`.
- Usa un comando con opzione numerica per mostrare solo le prime N righe.
- Usa un comando con opzione numerica per mostrare solo le ultime N righe.

---

## Esercizio 2 (facile-intermedio) — Conteggi e output


1. Conta quante righe ha `frasi_cliniche.txt`.
2. Conta quanti caratteri ha `referto_mock.txt`.
3. Salva entrambi i risultati in `Lezioni/lezione1_pratica_bash/output_es2.txt`.
4. Aggiungi una riga finale: `Controllo completato`.

### Come impostare i comandi
- Usa `wc` con l'opzione per il conteggio delle righe.
- Usa `wc` con l'opzione per il conteggio dei caratteri.
- Reindirizza il primo output su file con `>` e aggiungi il secondo con `>>`.
- Usa `echo` con `>>` per aggiungere la riga finale.
- Se hai dubbi sulle opzioni, consulta l'helper del comando (`wc --help`).

---

## Esercizio 3 (intermedio) — Ricerca parole con `grep`

1. Cerca nel file `frasi_cliniche.txt` tutte le righe che contengono `paziente`.
2. Cerca tutte le righe che contengono `terapia` (senza distinzione maiuscole/minuscole).
3. Salva le righe con `paziente` in `Lezioni/lezione1_pratica_bash/paziente_hits.txt`.

### Come impostare i comandi
- Usa `grep` con pattern testuale e percorso del file.
- Per ricerca case-insensitive usa l'opzione dedicata di `grep`.
- Combina `grep` con `>` per salvare i risultati su file.
- Per vedere tutte le opzioni disponibili, usa `grep --help`.

---

## Esercizio 4 (intermedio) — Sostituzione testo con `sed`
**Tempo:** 10 minuti

1. Prendi `referto_mock.txt`.
2. Sostituisci la parola `stabile` con `monitorato`.
3. Salva il risultato in `referto_editato.txt`.
4. Verifica che `monitorato` compaia nel nuovo file.

### Come impostare i comandi
- Usa `sed` con una sostituzione (`s/parolavecchia/parolanuova/g`).
- Reindirizza l'output su un nuovo file, senza sovrascrivere l'originale.
- Verifica il risultato cercando il termine sostitutivo nel file prodotto.
- Per opzioni e varianti, consulta `sed --help`.

---

## Esercizio 5 (più difficile) — Commentario su script `.sh`
**Tempo:** 20 minuti

In questo esercizio lo script è **già pronto**: `Lezioni/lezione1_pratica_bash/sostituisci_parola.sh`.

Obiettivo: leggere lo script, capirne la logica e provare a eseguirlo con i tuoi parametri.

### Cosa fare
1. Apri il file e visualizza il contenuto (senza modificarlo).
2. Individua nel codice:
   - dove vengono letti i parametri (`$1`, `$2`, `$3`, `$4`);
   - il comando che fa la sostituzione (`sed`);
   - la riga che stampa il messaggio finale.
3. Rendilo eseguibile.
4. Prova a eseguirlo su `materiali/frasi_cliniche.txt`.
5. Verifica il file di output generato.

### Aiutino (non soluzione completa)
- Prima di eseguirlo, assicurati che abbia permessi di esecuzione.
- Ricorda: lo script si aspetta **4 argomenti** in questo ordine:
  1) file input, 2) parola da cercare, 3) parola sostitutiva, 4) file output.
- Se non ricordi la sintassi, usa gli helper: `bash --help`, `chmod --help`, `sed --help`.

---

## Debrief finale (5 minuti)

Cosa abbiamo imparato:

1. orientarsi nelle cartelle e leggere file `.txt`;
2. contare righe/caratteri;
3. cercare pattern con `grep`;
4. fare sostituzioni base con `sed`;
5. automatizzare un compito semplice con uno script `.sh`.

---

## Nota per il docente

Per evitare che gli studenti vedano le soluzioni, non committare file di soluzione nel repository condiviso.

Per vedere/modificare tu le soluzioni: copia `SOLUZIONI_ISTRUTTORE.template.md` in `private_instructor/lezione1/SOLUZIONI_ISTRUTTORE.md` e lavora su quel file locale (ignorato da Git).
