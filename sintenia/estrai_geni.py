import os
import glob
import re
import pandas as pd

gff_folder = "gff3"
output_csv = "gene_positions.csv"

genes_of_interest = [
    "MTNR1",
    "GPR50",
    "Mel1c",
    "melatonin receptor",
    "Mtr1a",
    "Mtr1b",
    "Mtr1c"
]

# Fallback: locus_tag espliciti per genomi con annotazione "grezza"
# dove il campo Name/product non contiene info biologica utile
explicit_locus_tags = {
    "Amazona_aestiva.gff3": {
        "AAES_125952": "MTNR1A",
        "AAES_107064": "MTNR1B",
        "AAES_23638":  "MTNR1C",
    }
}

results = []

gff_files = sorted(glob.glob(os.path.join(gff_folder, "*.gff3")))

print(f"\nFound {len(gff_files)} GFF3 files\n")

for gff in gff_files:

    fname = os.path.basename(gff)
    print(f"Reading {fname}")

    species = os.path.splitext(fname)[0]

    chr_lengths = {}

    with open(gff) as infile:
        for line in infile:
            if line.startswith("##species"):
                tmp = line.strip().split()
                if len(tmp) > 1:
                    candidate = " ".join(tmp[1:])
                    if "http" not in candidate:
                        species = candidate
            elif line.startswith("##sequence-region"):
                tmp = line.strip().split()
                chromosome = tmp[1]
                length = int(tmp[3])
                chr_lengths[chromosome] = length

    hits = 0
    seen_genes = set()
    fallback_map = explicit_locus_tags.get(fname, {})

    with open(gff) as infile:
        for line in infile:
            if line.startswith("#"):
                continue
            fields = line.rstrip().split("\t")
            if len(fields) < 9:
                continue
            if fields[2] != "gene":
                continue

            attributes = fields[8].lower()

            gene_key_match = re.search(r"ID=([^;]+)", fields[8])
            gene_key = gene_key_match.group(1) if gene_key_match else None

            locus_tag_match = re.search(r"locus_tag=([^;]+)", fields[8])
            locus_tag = locus_tag_match.group(1) if locus_tag_match else None

            matched_term = None

            # 1) prova prima con la lista esplicita (fallback per genomi grezzi)
            if locus_tag and locus_tag in fallback_map:
                matched_term = fallback_map[locus_tag]
            else:
                # 2) altrimenti cerca per keyword generiche
                for search_term in genes_of_interest:
                    if search_term.lower() in attributes:
                        matched_term = search_term
                        break

            if matched_term is None:
                continue

            if gene_key and gene_key in seen_genes:
                continue
            if gene_key:
                seen_genes.add(gene_key)

            matched_name = matched_term
            m = re.search(r"Name=([^;]+)", fields[8])
            if m:
                matched_name = m.group(1)

            gene_field_match = re.search(r"[;\t]gene=([^;]+)", fields[8])
            gene_symbol = gene_field_match.group(1) if gene_field_match else ""

            chromosome = fields[0]

            results.append({
                "Species": species,
                "SearchTerm": matched_term,
                "MatchedGene": matched_name,
                "GeneSymbol": gene_symbol,
                "LocusTag": locus_tag,
                "Chromosome": chromosome,
                "GeneStart": int(fields[3]),
                "GeneEnd": int(fields[4]),
                "Strand": fields[6],
                "ChromosomeLength": chr_lengths.get(chromosome)
            })
            hits += 1

    print(f" {hits} matching genes found\n")

results = pd.DataFrame(results)
results = results.sort_values(["Species", "Chromosome", "GeneStart"])
results.to_csv(output_csv, index=False)

print("=======================================")
print(f"Finished!")
print(f"Total genes found : {len(results)}")
print(f"Output written to : {output_csv}")
print("=======================================")
