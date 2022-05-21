setwd("C:/Users/songo/Documents/2022_RWorkspace")

install.packages("devtools")
library(devtools)

# https://www.bioconductor.org/install/
# if install_github("microbiome/microbiome") does not work, execute code below
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install(version = "3.15")

library(BiocManager)
install_github("microbiome/microbiome")

# +++++++++++++++++++++++++++++++++
# Alpha diversity tutorial start
# +++++++++++++++++++++++++++++++++

library(microbiome)
library(knitr)

# Use dietswap data from microbiome package
data(dietswap)# S4 object load 하기 위해 data() 사용
pseq <- dietswap
View(pseq)

tab <-microbiome::alpha(pseq, index = "all")
kable(head(tab))
View(tab)

## Richness
# This returns observed richness with given detection threshold
tab <- richness(pseq)
kable(head(tab))

# Dominance
## The dominance index refers to the abundance of the most abundant species. 
tab <- dominance(pseq, index = "all")
kable(head(tab))

# function to list the dominating (most abundant) taxa in each sample
dominant(pseq)

## Rarity
tab <- rarity(pseq, index = "all")
kable(head(tab))
colnames(tab)

d <- alpha(pseq, index="evenness_simpson")
d

## Visualize alpha diversity: shannon
p.shannon <- boxplot_alpha(pseq, 
                           index = "shannon",
                           x_var = "sex",
                           fill.colors = c(female="cyan4", male="deeppink4"))

p.shannon <- p.shannon + theme_minimal() + 
  labs(x="Sex", y="Shannon diversity") +
  theme(axis.text = element_text(size=12),
        axis.title = element_text(size=16),
        legend.text = element_text(size=12),
        legend.title = element_text(size=16))
p.shannon

## 응용 (1)
## Visualize alpha diversity: chao1
p.chao1 <- boxplot_alpha(pseq, 
                           index = "chao1",
                           x_var = "sex",
                           fill.colors = c(female="cyan4", male="deeppink4"))

p.chao1 <- p.chao1 + theme_minimal() + 
  labs(x="Sex", y="Chao1 diversity") +
  theme(axis.text = element_text(size=12),
        axis.title = element_text(size=16),
        legend.text = element_text(size=12),
        legend.title = element_text(size=16))
p.chao1

## 응용 (2)
## Visualize alpha diversity: chao1 acc to group
p.chao1_g <- boxplot_alpha(pseq, 
                         index = "chao1",
                         x_var = "group",)

p.chao1_g <- p.chao1_g + theme_minimal() + 
  labs(x="Group", y="Chao1 diversity") +
  theme(axis.text = element_text(size=12),
        axis.title = element_text(size=16),
        legend.text = element_text(size=12),
        legend.title = element_text(size=16))
p.chao1_g


## 응용 (3)
## Visualize alpha diversity: chao1 acc to bmi_group
p.chao1_bg <- boxplot_alpha(pseq, 
                           index = "chao1",
                           x_var = "bmi_group",)

p.chao1_bg <- p.chao1_bg + theme_minimal() + 
  labs(x="Bmi_group", y="Chao1 diversity") +
  theme(axis.text = element_text(size=12),
        axis.title = element_text(size=16),
        legend.text = element_text(size=12),
        legend.title = element_text(size=16))
p.chao1_bg


## Testing differences in alpha diversity

# Construct the data
d <- meta(pseq)
d$diversity <- microbiome::diversity(pseq, "shannon")$shannon
# Split the values by group
spl <- split(d$diversity, d$sex)
# Kolmogorov-Smironv test
pv <- ks.test(spl$female, spl$male)$p.value
# Adjust the p-value
padj <- p.adjust(pv)
padj

# Viewing data inside dietswap
# package required to use methods related to s4 object
BiocManager::install("ALL")
library(ALL)

# In order to reference object inside s4 object, the "@" operator or slot() should be used
# Data inside an S4 class are organized into slots. You access slots by using either ‘@’ or the ’slots() function
# For more information refer to: https://kasperdanielhansen.github.io/genbioconductor/html/R_S4.html
getClass("phyloseq")
pseq@otu_table
nrow(pseq@otu_table)
View(pseq@otu_table)
