# Analisi Filogenetica dei Recettori della Melatonina nei Tetrapodi

## Tesi Magistrale — Sara Mattiolo
Università di Bologna — Laurea Magistrale in Biodiversità ed Evoluzione — 2025

---

## Descrizione del Progetto
Questo repository contiene la pipeline bioinformatica e i risultati dell'analisi filogenetica dei recettori della melatonina (MTNR1A, MTNR1B, MTNR1C) in 839 specie di tetrapodi appartenenti a nove gruppi tassonomici principali.

---

## Dataset
- **Fonte:** OrthoDB (orthogroup 181742at32523)
- **Sequenze:** 2.121 sequenze CDS
- **Specie:** 839 specie uniche di tetrapodi
- **Outgroup:** Rodopsina (RHO) di *Homo sapiens* (U49742.1) e *Bos taurus* (AH001149.2)

---

## Pipeline
1. **Recupero e pulizia dei dati** — download da OrthoDB, standardizzazione degli header
2. **Allineamento multiplo** — MAFFT v7.526 (--auto)
3. **Filtraggio dell'allineamento** — AliFilter v1.0.1 (845 posizioni conservate)
4. **Inferenza filogenetica** — IQ-TREE2 v2.3.6 (-m TEST -B 1000)
5. **Aggiunta dell'outgroup** — sequenze di rodopsina aggiunte con MAFFT --add

---

## Software
| Strumento | Versione | Utilizzo |
|-----------|---------|-------|
| MAFFT | 7.526 | Allineamento multiplo |
| AliFilter | 1.0.1 | Filtraggio allineamento |
| IQ-TREE2 | 2.3.6 | Inferenza filogenetica |
| R | 4.4.2 | Analisi statistiche e visualizzazione |
| ggplot2 | 4.0.2 | Boxplot |
| ape | 5.8 | Manipolazione alberi |

---

## Risultati
- Albero filogenetico con 2.128 taxa radicato con outgroup opsine
- Analisi della distribuzione delle lunghezze dei rami (test di Kruskal-Wallis)
- MTNR1C assente in tutti i gruppi di mammiferi — multipli eventi di perdita indipendenti
- Amphibia mostra rami significativamente più lunghi per MTNR1A (p = 4.27e-14)

---

## Contatti
Sara Mattiolo — sara.mattiolo@studio.unibo.it
