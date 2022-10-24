# 221024 Chen analysis (paired-end data)
# 220804 LTY
# Chen2021 data R analysis

library(remotes)
library(qiime2R)

physeq2_Chavez<-qza_to_phyloseq(features="./Chavez/dada2_table.qza",
                         tree="./Chavez/tree.qza",
                         "./Chavez/taxonomy.qza",
                         metadata = "./Chavez/Chavez2019_metadata.tsv")
physeq2_Chavez

pseq_t2_Chavez <- transform(physeq2_Chavez, "compositional") 
write.csv(pseq_t2_Chavez@otu_table,"Chavez_LTY.csv", row.names = TRUE)

library(hrbrthemes)
library(gcookbook)
library(tidyverse)

library(microbiome)
library(dplyr)

# Pick sample subset

pseq3_Chavez <- physeq2_Chavez %>%aggregate_taxa(level = "Phylum") %>%   microbiome::transform(transform = "compositional")
pseq3_Chavez


p_composition_barplot_Chavez <- pseq3_Chavez %>%
  plot_composition(sample.sort = "Firmicutes", otu.sort = "abundance") +
  # Set custom colors
  scale_fill_manual("Phylum",values = default_colors("Phylum")[taxa(pseq3_Chavez)]) +
  scale_y_continuous(label = scales::percent) + 
  theme_ipsum(grid="Y") +
  # Removes sample names and ticks
  theme(axis.text.x=element_blank(), axis.ticks.x=element_blank())

print(p_composition_barplot_Chavez)

## Relative abundance according to group
# averaged by group
# group by phyla
pseq_t2_Chavez <- transform(physeq2_Chavez, "compositional") 
pseq_t2_Chavez <- aggregate_rare(pseq_t2_Chavez, level = "Phylum", detection = 0.1/100, prevalence = 10/100)
p4_Chavez <- plot_composition(pseq_t2_Chavez,
                       average_by = "State",
                       otu.sort="abundance") +
  scale_fill_brewer("Phyla", palette = "Paired") +
  theme_ipsum(grid="Y") +
  theme(axis.text.x = element_text(angle=90, hjust=1),
        legend.text = element_text(face = "italic"))
print(p4_Chavez)

p_c <- plot_composition(pseq_t2_Chavez, average_by = "State", otu.sort="abundance")
p_c

# alpha diversity
p.chao1.values_Chavez <-microbiome::alpha(physeq2_Chavez, index = "chao1")
p.chao1.values_Chavez
library(dplyr)
summarise(p.chao1.values_Chavez)
p.chao1 <- boxplot_alpha(physeq2_Chavez, 
                         index = "chao1",
                         x_var = "State") + scale_x_discrete(limits = c("Control", "Obesity", "MetabolicSyndrome")) + scale_fill_manual(values= c("#F8766D", "#00B8E7", "#00BE67"))
p.chao1

# shannon
p.shannon.values_Chavez <-microbiome::alpha(physeq2_Chavez, index = "shannon")
p.shannon.values_Chavez
summarise(p.chao1.values_Chavez)
p.shannon <- boxplot_alpha(physeq2_Chavez, 
                         index = "shannon",
                         x_var = "State")+ scale_x_discrete(limits = c("Control", "Obesity", "MetabolicSyndrome")) + scale_fill_manual(values= c("#F8766D", "#00B8E7", "#00BE67"))

p.shannon

# simpson
p.simpson.values_Chavez <-microbiome::alpha(physeq2_Chavez, index = "simpson")
p.simpson.values_Chavez
summarise(p.simpson.values_Chavez)
p.simpson <- boxplot_alpha(physeq2_Chavez, 
                           index = "simpson",
                           x_var = "State")+ scale_x_discrete(limits = c("Control", "Obesity", "MetabolicSyndrome")) + scale_fill_manual(values= c("#F8766D", "#00B8E7", "#00BE67"))

p.simpson

# evenness_simpson
p.evenness_simpson.values_Chavez <-microbiome::alpha(physeq2_Chavez, index = "evenness_simpson")
p.evenness_simpson <- boxplot_alpha(physeq2_Chavez, 
                           index = "evenness_simpson",
                           x_var = "State")+ scale_x_discrete(limits = c("Control", "Obesity", "MetabolicSyndrome")) + scale_fill_manual(values= c("#F8766D", "#00B8E7", "#00BE67"))

p.evenness_simpson

# observed
p.observed.values_Chavez <-microbiome::alpha(physeq2_Chavez, index = "observed")
p.observed.values_Chavez
summarise(p.observed.values_Chavez)
p.observed <- boxplot_alpha(physeq2_Chavez, 
                           index = "observed",
                           x_var = "State")+ scale_x_discrete(limits = c("Control", "Obesity", "MetabolicSyndrome")) + scale_fill_manual(values= c("#F8766D", "#00B8E7", "#00BE67"))

p.observed

# relative abundance
# according to family
pseq_t2_Chavez <- transform(physeq2_Chavez, "compositional")
pseq_family_Chavez <- aggregate_rare(pseq_t2_Chavez, level = "Family", detection = 10/100, prevalence = 50/100)

pseq_family_Chavez

p_family_Chavez <- plot_composition(pseq_family_Chavez,
                             taxonomic.level = "Family",
                             sample.sort = "State",
                             x.label = "State",
                             average_by = "State") +
  scale_fill_brewer("Family", palette = "Paired") +
  guides(fill = guide_legend(ncol = 1)) +
  scale_y_percent() +
  labs(x = "Samples", y = "Relative abundance (%)",
       title = "Relative abundance of Family") + 
  theme_ipsum(grid="Y") +
  theme(axis.text.x = element_text(angle=90, hjust=1),
        legend.text = element_text(face = "italic"))
print(p_family_Chavez) 
