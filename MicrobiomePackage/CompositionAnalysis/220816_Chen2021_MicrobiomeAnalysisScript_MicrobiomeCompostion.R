# 220816 
# package: Microbiome
# Microbiome compostion
# https://microbiome.github.io/tutorials/Composition.html

# import qiime2 artifacts into phyloseq object for use in Microbiome package
library(remotes)
library(qiime2R)

physeq2<-qza_to_phyloseq(features="./ChenAll/dada2_table.qza",
                         tree="./ChenAll/tree.qza",
                         "./ChenAll/taxonomy2.qza",
                         metadata = "./ChenALl/Chenmanifest_all.tsv")
physeq2

# start tutorial

# Make sure we use functions from correct package
transform <- microbiome::transform

pseq_t2 <- physeq2

# Merge rare taxa to speed up examples
pseq_t2 <- transform(physeq2, "compositional")
pseq_t2 <- aggregate_rare(pseq_t2, level = "Phylum", detection = 1/100, prevalence = 50/100)
pseq_t2

# composition barplots
install.packages("gcookbook")

library(hrbrthemes)
library(gcookbook)
library(tidyverse)

library(microbiome)
library(dplyr)

# Limit the analysis on core taxa and specific sample group
# Relative abundance data according to phylum level

rank_names(pseq_t2)

# according to phylum
pseq_t2 <- aggregate_rare(pseq_t2, level = "Phylum", detection = 1/100, prevalence = 10/100)

pseq_phylum <- aggregate_rare(pseq_t2, level = "Phylum", detection = 0.1/100, prevalence = 10/100)
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
pseq_class <- aggregate_rare(pseq_t2, level = "Class", detection = 1/100, prevalence = 50/100)

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
pseq_order <- aggregate_rare(pseq_t2, level = "Order", detection = 1/100, prevalence = 50/100)

pseq_order

p_order <- plot_composition(pseq_order,
                            taxonomic.level = "Order",
                            sample.sort = "diet",
                            x.label = "diet") +
  scale_fill_brewer("Order", palette = "Paired") +
  guides(fill = guide_legend(ncol = 1)) +
  scale_y_percent() +
  labs(x = "Samples", y = "Relative abundance (%)",
       title = "Relative abundance data") + 
  theme_ipsum(grid="Y") +
  theme(axis.text.x = element_text(angle=90, hjust=1),
        legend.text = element_text(face = "italic"))
print(p_order) 

# according to family
pseq_t2 <- transform(physeq2, "compositional")
pseq_family <- aggregate_rare(pseq_t2, level = "Family", detection = 1/100, prevalence = 50/100)

pseq_family

p_family <- plot_composition(pseq_family,
                             taxonomic.level = "Family",
                             sample.sort = "diet",
                             x.label = "diet") +
  scale_fill_brewer("Family", palette = "Paired") +
  guides(fill = guide_legend(ncol = 1)) +
  scale_y_percent() +
  labs(x = "Samples", y = "Relative abundance (%)",
       title = "Relative abundance data") + 
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
pseq_genus <- aggregate_rare(pseq_t2, level = "Genus", detection = 1/100, prevalence = 50/100)

pseq_genus

p_genus <- plot_composition(pseq_genus,
                             taxonomic.level = "Genus",
                             sample.sort = "diet",
                             x.label = "diet") +
  scale_fill_brewer("Genus", palette = "Paired") +
  guides(fill = guide_legend(ncol = 1)) +
  scale_y_percent() +
  labs(x = "Samples", y = "Relative abundance (%)",
       title = "Relative abundance data") + 
  theme_ipsum(grid="Y") +
  theme(axis.text.x = element_text(angle=90, hjust=1),
        legend.text = element_text(face = "italic"))
print(p_genus) 


# averaged by group
# group by phyla
pseq_t2 <- transform(physeq2, "compositional")
pseq_t2 <- aggregate_rare(pseq_t2, level = "Phylum", detection = 1/100, prevalence = 50/100)
p4 <- plot_composition(pseq_t2,
                      average_by = "diet", 
                      transform = "compositional") +
  scale_fill_brewer("Phyla", palette = "Paired") +
  theme_ipsum(grid="Y") +
  theme(axis.text.x = element_text(angle=90, hjust=1),
        legend.text = element_text(face = "italic"))
print(p4)

# group by family

pseq_t2 <- transform(physeq2, "compositional")
pseq_t2 <- aggregate_rare(pseq_t2, level = "Family", detection = 1/100, prevalence = 50/100)
p4 <- plot_composition(pseq_t2,
                       average_by = "diet", 
                       transform = "compositional") +
  scale_fill_brewer("Family", palette = "Paired") +
  theme_ipsum(grid="Y") +
  theme(axis.text.x = element_text(angle=90, hjust=1),
        legend.text = element_text(face = "italic"))
print(p4)

## Composition heatmaps

# group by phyla
pseq_t2 <- transform(physeq2, "compositional")
pseq_t2 <- aggregate_rare(pseq_t2, level = "Family", detection = 1/100, prevalence = 50/100)

pseq_t2 <- aggregate_taxa(pseq_t2, level = "Family")


p7 <- pseq_t2 %>% 
  plot_composition(plot.type = "heatmap",
                   sample.sort = "neatmap", 
                   otu.sort = "neatmap") +
  theme(axis.text.y=element_blank(), 
        axis.ticks.y = element_blank(), 
        axis.text.x = element_text(size = 9, hjust=1),
        legend.text = element_text(size = 8)) 
print(p7)
