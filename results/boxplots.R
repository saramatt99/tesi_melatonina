library(ape)
library(ggplot2)
library(dplyr)

# ============================================================
# Leggi l'albero in formato NEXUS
# ============================================================
tree <- read.nexus("~/tesi_melatonina/tree/melatonin_tree_outgroup.treefile")

# Estrai lunghezze di ramo
taxa <- tree$tip.label
edge_idx <- match(1:length(taxa), tree$edge[,2])
branch_lengths <- tree$edge.length[edge_idx]

branch_data <- data.frame(
  taxon = taxa,
  branch_length = branch_lengths,
  stringsAsFactors = FALSE
)

cat("Taxa totali:", nrow(branch_data), "\n")
cat("Esempio taxa:\n")
print(head(branch_data$taxon))

# ============================================================
# Classifica per recettore
# ============================================================
branch_data$receptor <- "Other"
branch_data$receptor[grepl("MTNR1A", branch_data$taxon)] <- "MTNR1A"
branch_data$receptor[grepl("MTNR1B", branch_data$taxon)] <- "MTNR1B"
branch_data$receptor[grepl("MTNR1C", branch_data$taxon)] <- "MTNR1C"
branch_data$receptor[grepl("GPR50",  branch_data$taxon)] <- "GPR50"

# ============================================================
# Classifica per gruppo tassonomico dal nome del taxon
# ============================================================
primates <- c("Homo_sapiens","Pan_troglodytes","Pan_paniscus","Gorilla_gorilla",
  "Pongo_pygmaeus","Pongo_abelii","Symphalangus_syndactylus","Nomascus_leucogenys",
  "Hylobates_pileatus","Hylobates_moloch","Hoolock_leuconedys",
  "Macaca_mulatta","Macaca_fascicularis","Macaca_nemestrina","Macaca_thibetana",
  "Papio_anubis","Lophocebus_aterrimus","Cercocebus_atys","Mandrillus_sphinx",
  "Mandrillus_leucophaeus","Theropithecus_gelada","Cercopithecus_mona",
  "Chlorocebus_sabaeus","Erythrocebus_patas","Colobus_guereza",
  "Colobus_angolensis","Rhinopithecus_roxellana","Rhinopithecus_bieti",
  "Pygathrix_nigripes","Trachypithecus_francoisi","Piliocolobus_tephrosceles",
  "Callithrix_jacchus","Leontopithecus_rosalia","Saguinus_midas",
  "Aotus_nancymaae","Cebus_albifrons","Cebus_imitator","Sapajus_apella",
  "Saimiri_boliviensis","Pithecia_pithecia","Ateles_geoffroyi",
  "Alouatta_palliata","Lemur_catta","Eulemur_rufifrons","Prolemur_simus",
  "Propithecus_coquereli","Microcebus_murinus","Cheirogaleus_medius",
  "Daubentonia_madagascariensis","Otolemur_garnettii","Nycticebus_coucang",
  "Nycticebus_bengalensis","Loris_tardigradus","Carlito_syrichta",
  "Cephalopachus_bancanus")

rodentia <- c("Mus_musculus","Mus_spretus","Mus_caroli","Mus_pahari","Mus_minutoides",
  "Rattus_norvegicus","Rattus_rattus","Micromys_minutus","Apodemus_sylvaticus",
  "Tokudaia_osimensis","Arvicanthis_niloticus","Rhabdomys_pumilio",
  "Grammomys_surdaster","Mastomys_coucha","Rhynchomys_soricoides",
  "Meriones_unguiculatus","Psammomys_obesus","Acomys_cahirinus",
  "Acomys_dimidiatus","Acomys_russatus","Lophiomys_imhausi",
  "Cricetulus_griseus","Mesocricetus_auratus","Phodopus_roborovskii",
  "Microtus_ochrogaster","Microtus_oregoni","Microtus_fortis",
  "Neodon_shergylaensis","Chionomys_nivalis","Alexandromys_oeconomus",
  "Myodes_glareolus","Arvicola_amphibius","Peromyscus_leucopus",
  "Peromyscus_maniculatus","Peromyscus_eremicus","Peromyscus_californicus",
  "Onychomys_torridus","Reithrodontomys_megalotis","Neotoma_lepida",
  "Sigmodon_hispidus","Phyllotis_vaccarum","Nannospalax_galili",
  "Rhizomys_pruinosus","Eospalax_fontanierii","Jaculus_jaculus",
  "Dipus_sagitta","Dipodomys_ordii","Dipodomys_spectabilis",
  "Perognathus_longimembris","Thomomys_bottae","Geomys_bursarius",
  "Castor_canadensis","Marmota_marmota","Marmota_monax","Marmota_flaviventris",
  "Marmota_himalayana","Spermophilus_citellus","Urocitellus_parryii",
  "Ictidomys_tridecemlineatus","Tamias_sibiricus","Sciurus_carolinensis",
  "Sciurus_vulgaris","Glaucomys_volans","Muscardinus_avellanarius",
  "Cavia_porcellus","Cavia_tschudii","Hydrochoerus_hydrochaeris",
  "Octodon_degus","Chinchilla_lanigera","Erethizon_dorsatum",
  "Thryonomys_swinderianus","Heterocephalus_glaber","Fukomys_damarensis",
  "Hystrix_brachyura","Ctenodactylus_gundi","Ochotona_princeps",
  "Ochotona_curzoniae","Lepus_europaeus","Oryctolagus_cuniculus",
  "Sylvilagus_floridanus","Tupaia_chinensis")

carnivora <- c("Canis_lupus","Lycaon_pictus","Chrysocyon_brachyurus",
  "Vulpes_vulpes","Vulpes_lagopus","Vulpes_ferrilata","Urocyon_cinereoargenteus",
  "Nyctereutes_procyonoides","Otocyon_megalotis","Ursus_americanus",
  "Ursus_arctos","Ursus_maritimus","Tremarctos_ornatus","Ailuropoda_melanoleuca",
  "Lutra_lutra","Lontra_canadensis","Enhydra_lutris","Mustela_lutreola",
  "Mustela_putorius","Mustela_nigripes","Mustela_erminea","Neogale_vison",
  "Martes_foina","Martes_zibellina","Eira_barbara","Meles_meles",
  "Potos_flavus","Ailurus_styani","Zalophus_californianus","Eumetopias_jubatus",
  "Arctocephalus_gazella","Callorhinus_ursinus","Odobenus_rosmarus",
  "Halichoerus_grypus","Phoca_vitulina","Pusa_hispida","Leptonychotes_weddellii",
  "Mirounga_leonina","Mirounga_angustirostris","Neomonachus_schauinslandi",
  "Paguma_larvata","Cryptoprocta_ferox","Crocuta_crocuta","Hyaena_hyaena",
  "Proteles_cristata","Suricata_suricatta","Felis_catus","Prionailurus_bengalensis",
  "Prionailurus_viverrinus","Otocolobus_manul","Puma_concolor","Puma_yagouaroundi",
  "Acinonyx_jubatus","Lynx_canadensis","Lynx_pardinus","Lynx_rufus",
  "Leopardus_geoffroyi","Caracal_caracal","Panthera_leo","Panthera_pardus",
  "Panthera_tigris","Panthera_uncia","Neofelis_nebulosa")

cetacea <- c("Physeter_catodon","Monodon_monoceros","Delphinapterus_leucas",
  "Phocoena_phocoena","Phocoena_sinus","Neophocaena_sunameri",
  "Neophocaena_asiaeorientalis","Sousa_chinensis","Leucopleurus_acutus",
  "Inia_geoffrensis","Lipotes_vexillifer","Mesoplodon_densirostris",
  "Hyperoodon_ampullatus","Balaenoptera_musculus","Balaenoptera_acutorostrata",
  "Balaenoptera_physalus","Eschrichtius_robustus","Megaptera_novaeangliae",
  "Eubalaena_glacialis","Hippopotamus_amphibius")

chiroptera <- c("Pteropus_alecto","Pteropus_vampyrus","Pteropus_giganteus",
  "Macroglossus_sobrinus","Cynopterus_sphinx","Rousettus_aegyptiacus",
  "Megaderma_lyra","Megaderma_spasma","Rhinopoma_microphyllum",
  "Rhinolophus_ferrumequinum","Hipposideros_galeritus","Hipposideros_armiger",
  "Doryrhina_cyclops","Aselliscus_stoliczkanus","Eptesicus_fuscus",
  "Cnephaeus_nilssonii","Ia_io","Nyctalus_leisleri","Pipistrellus_kuhlii",
  "Vespertilio_murinus","Plecotus_auritus","Corynorhinus_townsendii",
  "Aeorestes_cinereus","Myotis_myotis","Myotis_davidii","Myotis_lucifugus",
  "Myotis_brandtii","Miniopterus_natalensis","Tadarida_brasiliensis",
  "Mops_condylurus","Molossus_molossus","Saccopteryx_bilineata",
  "Rhynchonycteris_naso","Taphozous_melanopogon","Artibeus_jamaicensis",
  "Sturnira_hondurensis","Glossophaga_mutica","Phyllostomus_hastatus",
  "Phyllostomus_discolor","Desmodus_rotundus","Pteronotus_parnellii")

reptilia <- c("Caretta_caretta","Chelonia_mydas","Dermochelys_coriacea",
  "Chelydra_serpentina","Chrysemys_picta","Trachemys_scripta","Malaclemys_terrapin",
  "Terrapene_carolina","Platysternon_megacephalum","Mauremys_mutica",
  "Mauremys_reevesii","Chelonoidis_abingdonii","Gopherus_flavomarginatus",
  "Gopherus_evgoodei","Pelodiscus_sinensis","Alligator_mississippiensis",
  "Alligator_sinensis","Crocodylus_porosus","Gavialis_gangeticus",
  "Sceloporus_undulatus","Phrynosoma_platyrhinos","Anolis_carolinensis",
  "Pogona_vitticeps","Phrynocephalus_forsythii","Zootoca_vivipara",
  "Podarcis_muralis","Podarcis_raffonei","Podarcis_lilfordi","Lacerta_agilis",
  "Varanus_komodoensis","Gekko_japonicus","Euleptes_europaea",
  "Sphaerodactylus_townsendi","Eublepharis_macularius","Hemicordylus_capensis",
  "Lerista_edwardsae","Notechis_scutatus","Pseudonaja_textilis",
  "Ophiophagus_hannah","Naja_naja","Thamnophis_elegans","Thamnophis_sirtalis",
  "Pantherophis_guttatus","Ahaetulla_prasina","Crotalus_tigris",
  "Protobothrops_mucrosquamatus","Python_bivittatus")

amphibia <- c("Pleurodeles_waltl","Rhinatrema_bivittatum","Geotrypetes_seraphini",
  "Microcaecilia_unicolor","Bombina_bombina","Xenopus_laevis","Xenopus_tropicalis",
  "Hymenochirus_boettgeri","Pelobates_cultripes","Leptobrachium_leishanense",
  "Spea_bombifrons","Bufo_bufo","Bufo_gargarizans","Hyla_sarda",
  "Ranitomeya_imitator","Engystomops_pustulosus","Eleutherodactylus_coqui",
  "Rana_temporaria","Staurois_parvus","Nanorana_parkeri")

# Funzione per ottenere il gruppo dal nome del taxon
get_group <- function(taxon_name) {
  # Estrai genere_specie (prime due parole)
  parts <- strsplit(taxon_name, "_")[[1]]
  genus_species <- paste(parts[1], parts[2], sep="_")
  genus <- parts[1]
  
  if(genus_species %in% primates || genus %in% sapply(strsplit(primates,"_"), `[`, 1)) {
    # Controlla match esatto prima
    if(any(sapply(primates, function(p) startsWith(taxon_name, p)))) return("Primates")
  }
  if(any(sapply(rodentia,   function(p) startsWith(taxon_name, p)))) return("Rodentia")
  if(any(sapply(carnivora,  function(p) startsWith(taxon_name, p)))) return("Carnivora")
  if(any(sapply(cetacea,    function(p) startsWith(taxon_name, p)))) return("Cetacea")
  if(any(sapply(chiroptera, function(p) startsWith(taxon_name, p)))) return("Chiroptera")
  if(any(sapply(reptilia,   function(p) startsWith(taxon_name, p)))) return("Reptilia")
  if(any(sapply(amphibia,   function(p) startsWith(taxon_name, p)))) return("Amphibia")
  if(any(sapply(primates,   function(p) startsWith(taxon_name, p)))) return("Primates")
  return("Aves")
}

branch_data$group <- sapply(branch_data$taxon, get_group)

cat("Distribuzione gruppi:\n")
print(table(branch_data$group))

# Filtra per recettori principali
branch_data <- branch_data[branch_data$receptor %in% c("MTNR1A","MTNR1B","MTNR1C"), ]

# Ordine gruppi
group_order <- c("Amphibia","Reptilia","Aves",
                 "Primates","Rodentia","Carnivora",
                 "Cetacea","Chiroptera","Aves")
branch_data$group <- factor(branch_data$group, 
                             levels = c("Amphibia","Reptilia","Aves",
                                        "Primates","Rodentia","Carnivora",
                                        "Cetacea","Chiroptera","Other_Mammals"))

# Normalizza per recettore
branch_data$branch_norm <- NA
for(rec in unique(branch_data$receptor)){
  idx <- branch_data$receptor == rec
  branch_data$branch_norm[idx] <- as.numeric(scale(branch_data$branch_length[idx]))
}

# ============================================================
# BOXPLOT 1 — Branch lengths normalizzate
# ============================================================
p1 <- ggplot(branch_data, aes(x = group, y = branch_norm, fill = group)) +
  geom_boxplot(outlier.size = 0.5, outlier.alpha = 0.4) +
  facet_wrap(~ receptor, ncol = 1) +
  theme_bw() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 9),
    strip.text = element_text(size = 12, face = "bold"),
    legend.position = "none"
  ) +
  labs(
    title = "Branch length distribution by taxonomic group",
    subtitle = "Normalized branch lengths (z-score) per receptor type",
    x = "Taxonomic group",
    y = "Normalized branch length (z-score)"
  ) +
  scale_fill_brewer(palette = "Set3")

ggsave("~/tesi_melatonina/results/boxplot_branchlengths.pdf", p1, width=10, height=12)
ggsave("~/tesi_melatonina/results/boxplot_branchlengths.png", p1, width=10, height=12, dpi=300)
cat("Boxplot 1 salvato!\n")

# ============================================================
# BOXPLOT 2 — Numero sequenze per gruppo e recettore
# ============================================================
species_count <- aggregate(taxon ~ group + receptor, data=branch_data, FUN=length)
names(species_count)[3] <- "n_species"

p2 <- ggplot(species_count, aes(x=group, y=n_species, fill=receptor)) +
  geom_bar(stat="identity", position="dodge") +
  theme_bw() +
  theme(
    axis.text.x = element_text(angle=45, hjust=1, size=9),
    legend.title = element_text(face="bold")
  ) +
  labs(
    title = "Number of sequences per taxonomic group and receptor",
    x = "Taxonomic group",
    y = "Number of sequences",
    fill = "Receptor"
  ) +
  scale_fill_manual(values = c("MTNR1A"="#E41A1C",
                                "MTNR1B"="#377EB8",
                                "MTNR1C"="#4DAF4A"))

ggsave("~/tesi_melatonina/results/boxplot_species_count.pdf", p2, width=10, height=6)
ggsave("~/tesi_melatonina/results/boxplot_species_count.png", p2, width=10, height=6, dpi=300)
cat("Boxplot 2 salvato!\n")
