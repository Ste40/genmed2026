# Lezione 2 — Esercitazione pratica sui formati bioinformatici

## Obiettivo

Allenarsi a leggere e ispezionare file **FASTQ, SAM (BAM) e VCF** usando solo i comandi base già visti nella lezione 1:

- `ls`, `cat`, `head`, `tail`, `less`
- `grep`, `wc`, `sed`
- redirezioni `>` `>>` e pipe `|`

> Nota didattica: il formato BAM reale è binario e normalmente si ispeziona con strumenti dedicati (es. `samtools`). In questa esercitazione usiamo un file **SAM** con lo stesso tipo di informazioni, così puoi lavorare con i comandi base.

---

## Materiali della lezione 2

Cartella: `Lezioni/lezione2_pratica_formati/materiali/`

- `mock_R1.fastq`
- `mock_R2.fastq`
- `mock_alignments.sam`
- `mock_variants.vcf`

Tutti i file sono mock e non compressi.

---

## Esercizio 1 (FASTQ base) — Struttura del record (15 min)

Usa `mock_R1.fastq`.

1. Qual è la riga dell'header in un record FASTQ?
2. Qual è la riga della sequenza?
3. Qual è la riga del separatore?
4. Qual è la quality string?
5. Estrai il primo record completo (4 righe) e salvalo in `output_es1_primo_record.txt`.

### Come impostare i comandi
- Mostra solo le prime N righe del file.
- Ricorda che ogni read FASTQ occupa 4 righe.
- Salva l'output in un nuovo file con redirezione.

---

## Esercizio 2 (FASTQ intermedio) — Conteggi e coerenza R1/R2 (15 min)

Usa `mock_R1.fastq` e `mock_R2.fastq`.

1. Quante reads ci sono in `R1`?
2. Quante reads ci sono in `R2`?
3. R1 e R2 sono coerenti come numero di reads?
4. Quanti header di R1 terminano con ` 1:N:0:ACGT`?
5. Quanti header di R2 terminano con ` 2:N:0:ACGT`?
6. Salva un mini-report in `report_fastq.txt`.

### Come impostare i comandi
- Conta le righe totali e convertile in numero di reads (4 righe = 1 read).
- Filtra le righe header con `grep`.
- Usa `echo` + `>>` per costruire il report passo-passo.

---

## Esercizio 3 (SAM/BAM concettuale) — Campi principali (15 min)

Usa `mock_alignments.sam`.

1. Quante righe di header SAM ci sono (iniziano con `@`)?
2. Quante righe di allineamento ci sono (non iniziano con `@`)?
3. Quanti allineamenti sono su `chr1`?
4. Quanti allineamenti sono su `chr2`?
5. Quante reads risultano non mappate (`FLAG = 4`)?
6. Estrai in un file `allineamenti_chr1.sam` solo gli allineamenti su `chr1` (mantieni anche l'header).

### Come impostare i comandi
- Usa `grep '^@'` per header e `grep -v '^@'` per i record.
- Per `FLAG=4` cerca i record con pattern tabulato dedicato.
- Per mantenere header + subset puoi unire output multipli nello stesso file.

---

## Esercizio 4 (VCF) — Varianti e filtri (15 min)

Usa `mock_variants.vcf`.

1. Quante righe di metadati ci sono (`##`)?
2. Qual è la riga di intestazione delle colonne (`#CHROM ...`)?
3. Quante varianti totali sono presenti?
4. Quante varianti hanno `FILTER=PASS`?
5. Quante varianti sono su `chr2`?
6. Crea `varianti_pass.vcf` con:
   - tutte le righe header (`##` e `#CHROM`)
   - solo le varianti con `FILTER=PASS`

### Come impostare i comandi
- Distingui righe di header da righe varianti usando pattern con `grep`.
- Cerca i record per cromosoma e stato FILTER con pattern nelle righe varianti.
- Costruisci un nuovo VCF concatenando prima header, poi record filtrati.

---

## Consegna consigliata (5 min finali)

Prepara nella cartella `Lezioni/lezione2_pratica_formati/`:

- `output_es1_primo_record.txt`
- `report_fastq.txt`
- `allineamenti_chr1.sam`
- `varianti_pass.vcf`
- `comandi_usati.txt` (lista dei comandi che hai eseguito)

