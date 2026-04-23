# Guida docente (riservata)

Questa guida riassume i casi aggiornati, i segnali didattici attesi e una proposta di difficoltà per discenti non esperti.

## Struttura corso aggiornata

- **Casi principali:** 6 (Case01–Case06)
- **Casi di riserva:** 5 (Case07–Case11)

## Sintesi dei 6 casi principali

1. **Case01 / dataset1**
   - Sospetto diagnostico: SNV in **gene2**.
   - QC: buono, senza criticità rilevanti.
   - Didattica: dal raw VCF emergono più candidati (~10), ma il sospetto clinico guida verso la variante coerente in gene2.

2. **Case02 / dataset2**
   - Sospetto diagnostico: **delezione** in gene3.
   - QC: sottopopolazione di reads corte.
   - Didattica: filtro lunghezza (`seqtk -L`) prima del mapping; in uscita restano più varianti, ma una sola delezione coerente.

3. **Case03 / dataset3**
   - Sospetto diagnostico: SNV in gene3.
   - QC: apparentemente buono.
   - Didattica: evidenziare copertura/supporto insufficiente su regione target → conclusione ragionata: **sequenziamento da ripetere**.

4. **Case04 / dataset4**
   - Sospetto diagnostico: piccola **inserzione** in gene1.
   - QC: presenza adapters riconoscibili (es. `AGATCGGAAGAGC`).
   - Didattica: trimming adapters con comandi minimali, poi pipeline standard e identificazione corretta.

5. **Case05 / dataset5**
   - Sospetto diagnostico: SNV in gene2.
   - QC: globale buono.
   - Didattica: variante candidata presente ma con confidenza bassa (QUAL ridotta), senza alternative robuste → **proporre repeat test**.

6. **Case06 / dataset6**
   - Sospetto diagnostico: SNV in gene1.
   - QC: calo qualità ultime 3 basi.
   - Didattica: trimming terminale (`cutadapt -u -3`), quindi re-run pipeline e identificazione variante.

## Casi di riserva (uso consigliato)

- **Case07:** controllo lineare (base training).
- **Case08:** segnale più rumoroso/eterogeneo (discussione filtri).
- **Case09:** basi N + bassa complessità (impatto qualità su calling).
- **Case10:** copertura ridotta (trade-off sensibilità/specificità).
- **Case11:** caso extra bilanciato per recuperi/verifiche.

## Ranking difficoltà suggerito (1=facile, 5=difficile)

### Principali
- Case01: **2/5**
- Case06: **2/5**
- Case04: **3/5**
- Case02: **3/5**
- Case05: **4/5**
- Case03: **4/5**

### Riserve
- Case07: **1/5**
- Case11: **2/5**
- Case10: **3/5**
- Case09: **4/5**
- Case08: **4/5**

## Domande guida per debrief in aula

1. Il QC giustifica il preprocessing applicato?
2. Quanta parte delle reads mappa correttamente e con che profondità media?
3. Quante varianti restano dopo filtri lenient/strict?
4. Il sospetto clinico è supportato da evidenza robusta (DP, QUAL, coerenza gene/locus)?
5. In quali casi è più corretto concludere con "dato insufficiente, ripetere"?
