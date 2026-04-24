library(ape)

tree <- read.tree("~/tesi_melatonina/tree/melatonin_tree_opsins_annotated.treefile")

labels <- as.character(tree$tip.label)
groups <- sub("_.*", "", labels)

colori <- c(
  "Amphibia"   = "#4DAF4A",
  "Reptilia"   = "#FF7F00",
  "Aves"       = "#377EB8",
  "Primates"   = "#E41A1C",
  "Rodentia"   = "#984EA3",
  "Carnivora"  = "#A65628",
  "Cetacea"    = "#00CED1",
  "Chiroptera" = "#F781BF",
  "Other"      = "#999999",
  "Outgroup"   = "#000000"
)

tip_colors <- colori[groups]
tip_colors[is.na(tip_colors)] <- "#999999"

pdf("~/tesi_melatonina/results/tree_circular.pdf", width = 14, height = 14)
plot(tree, type = "fan", tip.color = tip_colors, cex = 0.05, no.margin = TRUE)
legend("bottomleft", legend = names(colori), fill = colori, cex = 0.8, title = "Taxonomic group")
dev.off()

png("~/tesi_melatonina/results/tree_circular.png", width = 3000, height = 3000, res = 300)
plot(tree, type = "fan", tip.color = tip_colors, cex = 0.05, no.margin = TRUE)
legend("bottomleft", legend = names(colori), fill = colori, cex = 0.8, title = "Taxonomic group")
dev.off()

cat("Albero salvato!\n")
