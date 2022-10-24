#221024 Chen analysis (paired-end data)
# 220804 LTY
# Chen2021 data R analysis

library(remotes)
library(qiime2R)

physeq2<-qza_to_phyloseq(features="./ChenPE/dada2_table.qza",
                         tree="./ChenPE/tree.qza",
                         "./ChenPE/taxonomy.qza",
                         metadata = "./ChenPE/Chenmanifest_all.tsv")
physeq2
# Check relative abundance data


# Merge rare taxa to speed up examples
pseq_t2 <- transform(physeq2, "compositional")

# according to phylum
pseq_t2 <- aggregate_rare(pseq_t2, level = "Phylum", detection = 1/100, prevalence = 50/100)

pseq_phylum <- aggregate_rare(pseq_t2, level = "Phylum", detection = 1/100, prevalence = 10/100)
pseq_phylum

p_phylum <- plot_composition(pseq_phylum,
                             taxonomic.level = "Phylum",
                             sample.sort = "diet",
                             x.label = "diet") +
  scale_fill_brewer("Phyla", palette = "Paired") +
  guides(fill = guide_legend(ncol = 1)) +
  scale_y_percent() +
  labs(x = "Samples", y = "Relative abundance (%)",
       title = "Relative abundance data") + 
  theme_ipsum(grid="Y") +
  theme(axis.text.x = element_text(angle=90, hjust=1),
        legend.text = element_text(face = "italic"))
print(p_phylum) 

pseq_phylumtaxa <- aggregate_taxa(pseq_t2, level = "Phylum")
pseq_phylumtaxa

p_phylumtaxa <- plot_composition(pseq_phylumtaxa,
                                 taxonomic.level = "Phylum",
                                 sample.sort = "diet",
                                 x.label = "diet") +
  scale_fill_brewer("Phyla", palette = "Paired") +
  guides(fill = guide_legend(ncol = 1)) +
  scale_y_percent() +
  labs(x = "Samples", y = "Relative abundance (%)",
       title = "Relative abundance data") + 
  theme_ipsum(grid="Y") +
  theme(axis.text.x = element_text(angle=90, hjust=1),
        legend.text = element_text(face = "italic"))
print(p_phylumtaxa) 

# according to class
pseq_t2 <- transform(physeq2, "compositional")
pseq_class <- aggregate_rare(pseq_t2, level = "Class", detection = 0.1/100, prevalence = 10/100)

pseq_class

p_class <- plot_composition(pseq_class,
                            taxonomic.level = "Class",
                            sample.sort = "diet",
                            x.label = "diet") +
  scale_fill_brewer("Class", palette = "Paired") +
  guides(fill = guide_legend(ncol = 1)) +
  scale_y_percent() +
  labs(x = "Samples", y = "Relative abundance (%)",
       title = "Relative abundance data") + 
  theme_ipsum(grid="Y") +
  theme(axis.text.x = element_text(angle=90, hjust=1),
        legend.text = element_text(face = "italic"))
print(p_class) 

# according to order
pseq_t2 <- transform(physeq2, "compositional")
pseq_order <- aggregate_rare(pseq_t2, level = "Order", detection = 0.1/100, prevalence = 10/100)

pseq_order

p_order <- plot_composition(pseq_order,
                            taxonomic.level = "Order",
                            sample.sort = "diet",
                            x.label = "diet") +
  scale_fill_brewer("Order", palette = "Paired") +
  guides(fill = guide_legend(ncol = 1)) +
  scale_y_percent() +
  labs(x = "Samples", y = "Relative abundance (%)",
       title = "Relative abundance of Order") + 
  theme_ipsum(grid="Y") +
  theme(axis.text.x = element_text(angle=90, hjust=1),
        legend.text = element_text(face = "italic"))
print(p_order) 

# according to family
pseq_t2 <- transform(physeq2, "compositional")
pseq_family <- aggregate_rare(pseq_t2, level = "Family", detection = 0.1/100, prevalence = 10/100)

pseq_family

p_family <- plot_composition(pseq_family,
                             taxonomic.level = "Family",
                             sample.sort = "diet",
                             x.label = "diet") +
  scale_fill_brewer("Family", palette = "Paired") +
  guides(fill = guide_legend(ncol = 1)) +
  scale_y_percent() +
  labs(x = "Samples", y = "Relative abundance (%)",
       title = "Relative abundance of Family") + 
  theme_ipsum(grid="Y") +
  theme(axis.text.x = element_text(angle=90, hjust=1),
        legend.text = element_text(face = "italic"))
print(p_family) 

# aggregate_taxa(x, level, verbose = FALSE)
pseq_t2 <- transform(physeq2, "compositional")
pseq_familytaxa <- aggregate_taxa(pseq_t2, level = "Family")
pseq_familytaxa

p_familytaxa <- plot_composition(pseq_familytaxa,
                                 taxonomic.level = "Family",
                                 sample.sort = "diet",
                                 x.label = "diet") +
  guides(fill = guide_legend(ncol = 1)) +
  scale_y_percent() +
  labs(x = "Samples", y = "Relative abundance (%)",
       title = "Relative abundance data") + 
  theme_ipsum(grid="Y") +
  theme(axis.text.x = element_text(angle=90, hjust=1),
        legend.text = element_text(face = "italic"))
print(p_familytaxa) 




# according to genus
pseq_t2 <- transform(physeq2, "compositional")
pseq_genus <- aggregate_rare(pseq_t2, level = "Genus", detection = 0.1/100, prevalence = 10/100)

pseq_genus

p_genus <- plot_composition(pseq_genus,
                            taxonomic.level = "Genus",
                            sample.sort = "diet",
                            x.label = "diet") +
  scale_fill_brewer("Genus", palette = "Paired") +
  guides(fill = guide_legend(ncol = 1)) +
  scale_y_percent() +
  labs(x = "Samples", y = "Relative abundance (%)",
       title = "Relative abundance of Genus") + 
  theme_ipsum(grid="Y") +
  theme(axis.text.x = element_text(angle=90, hjust=1),
        legend.text = element_text(face = "italic"))
print(p_genus) 
