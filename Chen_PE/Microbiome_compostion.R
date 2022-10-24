# 221024 Chen2021 analysis (paired-end data)
# ABKefir mouse data (CD, HFD, HFABK, WD, WDABK, n=6 each)
# LTY

library(remotes)
library(qiime2R)

physeq2<-qza_to_phyloseq(features="./ChenPE/dada2_table.qza",
                         tree="./ChenPE/tree.qza",
                         "./ChenPE/taxonomy.qza",
                         metadata = "./ChenPE/Chenmanifest_all.tsv")
physeq2

# check phyloseq object
microbiome::summarize_phyloseq(physeq2)
otu_tab <- microbiome::abundances(physeq2)
tax_tab <- phyloseq::tax_table(physeq2)
# check 
tax_tab[1:5,1:5] # for my table show me [1 to 5 otu ids, 1 to 5 first five ranks]
# check 
otu_tab[1:5,1:5] # for my table show me [1 to 5 rows, 1 to 5 columns]

p.chao1.values <-microbiome::alpha(physeq2, index = "chao1")
p.chao1.values
library(dplyr)
summarise(p.chao1.values)
p.chao1 <- boxplot_alpha(physeq2, 
                         index = "chao1",
                         x_var = "diet")

p.chao1


p.shannon <- boxplot_alpha(physeq2, 
                           index = "shannon",
                           x_var = "diet")

p.shannon

## https://microbiome.github.io/tutorials/Composition.html
## Composition barplots
library(hrbrthemes)
library(gcookbook)
library(tidyverse)

# Pick sample subset
pseq3 <- physeq2 %>%aggregate_taxa(level = "Phylum") %>%   microbiome::transform(transform = "compositional")
pseq3

p_composition_barplot <- pseq3 %>%
  plot_composition(sample.sort = "Firmicutes", otu.sort = "abundance") +
  # Set custom colors
  scale_fill_manual("Phylum",values = default_colors("Phylum")[taxa(pseq3)]) +
  scale_y_continuous(label = scales::percent) + 
  theme_ipsum(grid="Y") +
  # Removes sample names and ticks
  theme(axis.text.x=element_blank(), axis.ticks.x=element_blank())

print(p_composition_barplot)
