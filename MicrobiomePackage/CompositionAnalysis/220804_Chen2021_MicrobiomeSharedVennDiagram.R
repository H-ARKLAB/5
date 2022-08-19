# 220804 LTY
# Chen2021 data R analysis

library(remotes)
library(qiime2R)

physeq2<-qza_to_phyloseq(features="./ChenAll/dada2_table.qza",
                        tree="./ChenAll/tree.qza",
                        "./ChenAll/taxonomy2.qza",
                        metadata = "./ChenALl/Chenmanifest_all.tsv")
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
summarise(p.chao1.values)
p.chao1 <- boxplot_alpha(physeq2, 
                         index = "chao1",
                         x_var = "diet")

p.chao1


p.shannon <- boxplot_alpha(physeq2, 
                         index = "shannon",
                         x_var = "diet")

p.shannon

library(microbiome)

# Construct the data
d <- meta(physeq2)
d$diversity <- microbiome::diversity(physeq2, "shannon")$shannon
# Split the values by group
spl <- split(d$diversity, d$diet)


# Kolmogorov-Smironv test
pv <- ks.test(spl$CD, spl$HFABK)$p.value
# Adjust the p-value
padj <- p.adjust(pv)

# additional alpha diversity analysis
library(microbiome)
install.packages('ggpubr')
library(ggpubr)
library(knitr)
library(dplyr)

ps1 <- prune_taxa(taxa_sums(physeq2) > 0, physeq2)

tab <- microbiome::alpha(ps1, index = "all")
kable(head(tab))

ps1.meta <- meta(ps1)
kable(head(ps1.meta))

# add diversity table to metadata
ps1.meta$Shannon <- tab$diversity_shannon 
ps1.meta$InverseSimpson <- tab$diversity_inverse_simpson

ps1.meta$Chao1 <- tab$chao1


diet <- levels(ps1.meta$diet)

diet

diet.pairs <- combn(seq_along(diet), 2, simplify = FALSE, FUN = function(i)diet[i])
print(diet.pairs)

#ps1.meta$'' <- alpha(ps1, index = 'shannon')
p1 <- ggviolin(ps1.meta, x = "diet", y = "Shannon",
               add = "boxplot", fill = "diet") 

print(p1)

p1 <- p1 + stat_compare_means(comparisons = diet.pairs) 
print(p1)

# Shared core with venn diagram
# physeq2
table(meta(physeq2)$diet, useNA = "always")

# convert to relative abundances
pseq.rel <- microbiome::transform(physeq2, "compositional")
pseq.rel


physeq2
View(physeq2@otu_table)
View(pseq.rel@otu_table)

# make a list of diet groups
diet_groups <- unique(as.character(meta(pseq.rel)$diet))
print(diet_groups)



list_core <- c() # an empty object to store information

for (n in diet_groups){ # for each variable n in dietgroup
  #print(paste0("Identifying Core Taxa for ", n))
  
  ps.sub <- subset_samples(pseq.rel, diet == n) # Choose sample from DiseaseState by n
  
  core_m <- core_members(ps.sub, # ps.sub is phyloseq selected with only samples from g 
                         detection = 0.001, # 0.001 in atleast 90% samples 
                         prevalence = 0.75)
  print(paste0("No. of core taxa in ", n, " : ", length(core_m))) # print core taxa identified in each DiseaseState.
  list_core[[n]] <- core_m # add to a list core taxa for each group.
  #print(list_core)
}


BiocManager::install("microbiomeutilities")
library(microbiomeutilities)


install.packages("eulerr") 
library(eulerr)

plot(venn(list_core))
    
install.packages("VennDiagram") 
library(VennDiagram)


diet_groups2 <- c("HFABK","HFD","CD")

list_core <- c() # an empty object to store information

for (n in diet_groups2){ # for each variable n in dietgroup
  #print(paste0("Identifying Core Taxa for ", n))
  
  ps.sub <- subset_samples(pseq.rel, diet == n) # Choose sample from DiseaseState by n
  
  core_m <- core_members(ps.sub, # ps.sub is phyloseq selected with only samples from g 
                         detection = 0.001, # 0.001 in atleast 90% samples 
                         prevalence = 0.75)
  print(paste0("No. of core taxa in ", n, " : ", length(core_m))) # print core taxa identified in each DiseaseState.
  list_core[[n]] <- core_m # add to a list core taxa for each group.
  #print(list_core)
}

plot(venn(list_core))


# Calculate compositional version of the data
# (relative abundances)
pseq.rel2 <- microbiome::transform(physeq2, "compositional")


#  prevalence of taxonomic groups
## Relative population frequencies; at 1% compositional abundance threshold
head(prevalence(pseq.rel2, detection = 1/100, sort = TRUE))

# Absolute population frequencies (sample count)
head(prevalence(pseq.rel2, detection = 1/100, sort = TRUE, count = TRUE))

core.taxa.standard <- core_members(pseq.rel2, detection = 0, prevalence = 50/100)

# A full phyloseq object of the core microbiota is obtained as follows
pseq.core <- core(pseq.rel2, detection = 0, prevalence = .5)


#We can also collapse the rare taxa into an “Other” category
pseq.core2 <- aggregate_rare(pseq.rel2, "Genus", detection = 0, prevalence = .5)

core.taxa <- taxa(pseq.core)
core.taxa

core.abundance <- sample_sums(core(pseq.rel2, detection = .01, prevalence = .95))

# With compositional (relative) abundances
det <- c(0, 0.1, 0.5, 2, 5, 20)/100
prevalences <- seq(.05, 1, .05)
#ggplot(d) + geom_point(aes(x, y)) + scale_x_continuous(trans="log10", limits=c(NA,1))


plot_core(pseq.rel2, 
          prevalences = prevalences, 
          detections = det, 
          plot.type = "lineplot") + 
  xlab("Relative Abundance (%)")


# Core with compositionals:
library(RColorBrewer)
library(reshape)

prevalences <- seq(.05, 1, .05)

detections <- round(10^seq(log10(0.01), log10(.2), length = 9), 3)

# Also define gray color palette
gray <- gray(seq(0,1,length=5))

#Added pseq.rel, I thin... must be checked if it was in the the rednred version,; where it is initialized
#pseq.rel<- microbiome::transform(pseq, 'compositional')
#min-prevalence gets the 100th highest prevalence
p <- plot_core(pseq.rel,
               plot.type = "heatmap", 
               colours = gray,
               prevalences = prevalences, 
               detections = detections, 
               min.prevalence = prevalence(pseq.rel, sort = TRUE)[100]) +
  labs(x = "Detection Threshold\n(Relative Abundance (%))") +
  
  #Adjusts axis text size and legend bar height
  theme(axis.text.y= element_text(size=8, face="italic"),
        axis.text.x.bottom=element_text(size=8),
        axis.title = element_text(size=10),
        legend.text = element_text(size=8),
        legend.title = element_text(size=10))

print(p)
