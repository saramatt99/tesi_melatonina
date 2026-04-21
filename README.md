# Phylogenetic Analysis of Melatonin Receptors in Tetrapods

## Master's Thesis — Sara Mattiolo
University of Bologna — 2025

---

## Project Description
This repository contains the bioinformatic pipeline and results for the phylogenetic analysis of melatonin receptors (MTNR1A, MTNR1B, MTNR1C) across 839 tetrapod species.

---

## Dataset
- **Source:** OrthoDB (orthogroup 181742at32523)
- **Sequences:** 2,121 CDS sequences
- **Species:** 839 unique tetrapod species
- **Outgroup:** Rhodopsin (RHO) of *Homo sapiens* (U49742.1) and *Bos taurus* (AH001149.2)

---

## Pipeline
1. **Data retrieval & cleaning** — OrthoDB download, header standardization
2. **Multiple sequence alignment** — MAFFT v7.526 (`--auto`)
3. **Alignment trimming** — trimAl v1.5 (`-automated1`)
4. **Phylogenetic inference** — IQ-TREE2 v2.3.6 (`-m TEST -B 1000`)
5. **Outgroup addition** — Rhodopsin sequences added via MAFFT `--add`

---

## Software
| Tool | Version | Usage |
|------|---------|-------|
| MAFFT | 7.526 | Multiple sequence alignment |
| trimAl | 1.5 | Alignment trimming |
| IQ-TREE2 | 2.3.6 | Phylogenetic inference |
| R | 4.4.2 | Statistical analysis & visualization |
| ggplot2 | 4.0.2 | Boxplots |
| ape | 5.8 | Tree manipulation |

---

## Repository Structure
---

## Results
- Phylogenetic tree with 2,128 taxa rooted with opsin outgroup
- Branch length distribution analysis (Kruskal-Wallis test)
- MTNR1C absent in all mammalian groups — multiple independent loss events
- Amphibia shows significantly longer branches for MTNR1A (p = 4.27 × 10⁻¹⁴)

---

## Contact
Sara Mattiolo — sara.mattiolo@studio.unibo.it
