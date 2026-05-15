
# Melatonin Receptors in Tetrapods — Phylogenetic Analysis

**Master's Thesis** | Sara Mattiolo | Università di Bologna — Biodiversità ed Evoluzione | 2026

---

## Project Overview

Phylogenetic analysis of melatonin receptors (MTNR1A, MTNR1B, MTNR1C) across tetrapods, using a bioinformatic pipeline that includes transmembrane domain validation, multiple sequence alignment, alignment filtering, and maximum likelihood phylogenetic inference.

---

## Dataset

- **Source:** OrthoDB (orthogroup 181742at32523)
- **Sequences:** 2,121 CDS sequences
- **Species:** 839 unique tetrapod species
- **Receptors:** MTNR1A (662), MTNR1B (636), MTNR1C (305), GPR50 (30)
- **Taxonomic groups:** Amphibia, Reptilia, Aves, Primates, Rodentia, Carnivora, Cetacea, Chiroptera, Other Mammals

---

## Pipeline

### 1. Data Retrieval & Cleaning
Sequences downloaded from OrthoDB and converted from RTF to FASTA format. Headers standardized to `Species_ReceptorType_GeneID`. Taxonomic annotation assigned to 9 groups.

### 2. Outgroup — 16 Opsin Sequences
Rhodopsin (RHO) CDS sequences from 16 mammalian species retrieved from NCBI and used as external outgroup. Species include *Homo sapiens*, *Bos taurus*, *Felis catus*, *Equus caballus*, *Sus scrofa*, *Ovis aries*, *Macaca mulatta*, *Pan troglodytes*, *Tursiops truncatus*, *Myotis lucifugus*, *Monodelphis domestica*, *Ornithorhynchus anatinus*, *Loxodonta africana*, *Dasypus novemcinctus*, *Rattus norvegicus*, and *Pteropus alecto*.

### 3. SCAMPI — Transmembrane Domain Validation
All 2,136 sequences (receptors + opsins) submitted to SCAMPI (Stockholm University) in 5 batches of 500 sequences each for transmembrane topology prediction.

| TM Domains | N. Sequences | % |
|---|---|---|
| 0–4 TM (anomalous) | 158 | 7.5% |
| 5 TM | 611 | 28.9% |
| 6 TM | 1,337 | 63.2% |
| 7 TM | 9 | 0.4% |
| **5–7 TM (retained)** | **1,957** | **92.5%** |

Sequences with fewer than 5 or more than 7 TM domains were removed as likely incomplete, truncated, or pseudogenic. All 16 opsin sequences passed validation (100% predicted TM proteins).

### 4. Multiple Sequence Alignment
Filtered dataset (1,977 sequences) aligned using MAFFT v7.526:
```bash
mafft --auto --thread -1 melatonin_with_all_opsins_filtered_clean.fasta > melatonin_with_all_opsins_filtered_aligned.fasta
```
Alignment length: **9,310 bp**

### 5. Alignment Filtering — AliFilter
AliFilter v1.0.1 (ML-based) used to remove uninformative alignment columns. AliFilter uses a machine learning model to identify informative columns regardless of outgroup divergence, making it ideal for datasets that include a divergent outgroup such as opsins.
```bash
AliFilter -i melatonin_with_all_opsins_filtered_aligned.fasta -o melatonin_with_all_opsins_filtered_trimmed.fasta -t dna
```
Result: **1,030 conserved positions** | Confidence: **97.02%**

### 6. Phylogenetic Inference — IQ-TREE2
Maximum likelihood tree inferred using IQ-TREE2 v2.3.6:
```bash
iqtree2 -s melatonin_with_all_opsins_filtered_trimmed.fasta -m TEST -B 1000 -T AUTO \
  -o Outgroup_Bos_taurus_Opsin_RHO_NM001014890,Outgroup_Felis_catus_Opsin_RHO_NM001009242 \
  --prefix melatonin_tree_filtered
```
- **Best-fit model:** SYM+I+G4 (BIC)
- **Bootstrap replicates:** 1,000 UFBoot

---

## Statistical Analysis

Branch length distributions compared across taxonomic groups using the Kruskal-Wallis test (normalized z-scores):

| Receptor | χ² | p-value | Result |
|---|---|---|---|
| MTNR1A | 80.29 | 4.27 × 10⁻¹⁴ | Significant |
| MTNR1B | 26.34 | 9.19 × 10⁻⁴ | Significant |
| MTNR1C | 11.73 | 2.84 × 10⁻³ | Significant |

Post-hoc pairwise Wilcoxon tests with Bonferroni correction:
- **MTNR1A:** Amphibia shows significantly longer branches than Aves, Reptilia, Rodentia and Carnivora
- **MTNR1B:** Chiroptera shows elevated branch lengths, possibly related to circadian rhythm adaptation
- **MTNR1C:** Present only in Amphibia, Reptilia and Aves — absent in all mammalian groups

---

## Repository Structure
tesi_melatonina/
├── fasta_raw/          # Raw and filtered FASTA sequences
├── alignment/          # MAFFT alignments
├── trimmed/            # AliFilter filtered alignments
├── tree/               # IQ-TREE2 output files
└── results/            # SCAMPI results, boxplots, final tree

---

## Tools & Versions

| Tool | Version | Purpose |
|---|---|---|
| MAFFT | 7.526 | Multiple sequence alignment |
| AliFilter | 1.0.1 | Alignment filtering |
| IQ-TREE2 | 2.3.6 | Phylogenetic inference |
| SCAMPI | — | TM domain prediction |
| R | 4.4.2 | Statistical analysis & visualization |
