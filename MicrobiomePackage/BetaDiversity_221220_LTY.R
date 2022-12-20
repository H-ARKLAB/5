# 2022.12.19
# Metateam
# Beta diveristy for article figures
# by: LTY

# tutorial link: https://microbiome.github.io/tutorials/TemporalMicrobiotaTrajectory.html

# install this pkg
install.packages("devtools")
devtools::install_github("microsud/jeevanuDB", force=TRUE)

library(microbiome)
library(jeevanuDB) # external database pkg for microbiome pkg with test data
library(dplyr)
library(ggplot2)
library(viridis)
library(knitr)

library(remotes)
library(qiime2R)
library(microbiome)
library(hrbrthemes)


arklab_physeq <-qza_to_phyloseq(features="./2022_2_ARKLAB_META/Beta/table_4.qza",
                         tree="./2022_2_ARKLAB_META/Beta/rooted-tree_4.qza",
                         "./2022_2_ARKLAB_META/Beta/taxonomy.qza",
                         metadata = "./2022_2_ARKLAB_META/Beta/HDSBIO_set2_metadata.tsv")


arklab_physeq

arklab_physeq.gut <- arklab_physeq

# remove asvs which are zero in all of these samples
arklab_physeq.gut <- prune_taxa(taxa_sums(arklab_physeq.gut) > 0, arklab_physeq.gut)
arklab_physeq.gut

# remove samples with less than 500 reads Note: this is user choice 
# here we just show example
arklab_physeq.gut <- prune_samples(sample_sums(arklab_physeq.gut) > 500, arklab_physeq.gut)
arklab_physeq.gut

# Covnert to relative abundances
arklab_physeq.gut.rel <- microbiome::transform(arklab_physeq.gut, "compositional")

## ordinatation analysis using PCoA
# Ordination object
arklab_physeq.ord <- ordinate(arklab_physeq.gut.rel, "PCoA")

# Ordination object plus all metadata, note: we use justDF=T. This will not return a plot but a data.frame
arklab_physeq.ordip <- plot_ordination(arklab_physeq.gut.rel, arklab_physeq.ord, justDF = T)
arklab_physeq.ordip
View(arklab_physeq.ordip)

# Get axis 1 and 2 variation
evals1 <- round(arklab_physeq.ord$values$Eigenvalues[1] / sum(arklab_physeq.ord$values$Eigenvalues) * 100, 2)
evals2 <- round(arklab_physeq.ord$values$Eigenvalues[2] / sum(arklab_physeq.ord$values$Eigenvalues) * 100, 2)

# theme_set(theme_bw(14))
# set colors
# get group names
unique(arklab_physeq.gut@sam_data$Region)
subject_cols <- c(LFD = "red", HFD = "blue", HAC03="green", GARCINIA="purple", HG="orange")

## Add trajectory for the subject of interest. Here, we randomnly choose subject F4
# arrange according to sampling time. Sort with increasing time


# choose data for subject F4
dfs <- subset(arklab_physeq.ordip, Region == "HFD")

# arrange according to sampling time. Sort with increasing time
dfs <- dfs %>%
  arrange(Region)


# use the ordip
# first step get blank plot
p <- ggplot(arklab_physeq.ordip, aes(x = Axis.1, y = Axis.2))

# add path (lines) join only those samples that are from F4

###### figure1_pcoa_bray_unweighted
p2 <- p +
  
  # now add a layer of points 
  geom_point(aes(color = Region), alpha = 0.6, size = 3) +
  scale_fill_brewer("Region", palette = "Paired") +
  xlab(paste("PCoA 1 (", evals1, "%)", sep = "")) +
  ylab(paste("PCoA 2 (", evals2, "%)", sep = "")) +
  theme_bw() +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  )
# coord_fixed(sqrt(evals[2] / evals[1]))

# Print figure
print(p2)
# scale_fill_brewer("Region", palette = "Paired")


library(phyloseq)
distanceMethodList
subject_cols <- c(LFD = "black", HFD = "white", HAC03="blue", GARCINIA="red", HG="darkgreen")


# 221220
# try diff versions
########################################################################
###### figure1_pcoa_bray
arklab_physeq.ord1 <- ordinate(arklab_physeq.gut.rel, "PCoA")
arklab_physeq.ordip1 <- plot_ordination(arklab_physeq.gut.rel, arklab_physeq.ord1, justDF = T)
arklab_physeq.ordip1

evals1_fig1 <- round(arklab_physeq.ord1$values$Eigenvalues[1] / sum(arklab_physeq.ord1$values$Eigenvalues) * 100, 2)
evals2_fig1 <- round(arklab_physeq.ord1$values$Eigenvalues[2] / sum(arklab_physeq.ord1$values$Eigenvalues) * 100, 2)

p_fig1 <- ggplot(arklab_physeq.ordip1, aes(x = Axis.1, y = Axis.2)) +
    geom_point(colour="black",size=2, alpha= 0.8, shape=21, stroke=0.75,
  aes(fill=factor(Region)))+
  scale_fill_manual("Region", values = subject_cols)  +
  xlab(paste("PCoA 1 (", evals1_fig1, "%)", sep = "")) +
  ylab(paste("PCoA 2 (", evals2_fig1, "%)", sep = "")) +
  theme_bw() +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  )+
  ggtitle("figure1_pcoa_bray")
print(p_fig1)

########################################################################
###### figure2_pcoa_unweighted_unifrac
arklab_physeq.ord2 <- ordinate(arklab_physeq.gut.rel, "PCoA",  distance = "uunifrac")
arklab_physeq.ordip2 <- plot_ordination(arklab_physeq.gut.rel, arklab_physeq.ord2, justDF = T)
arklab_physeq.ordip2

evals1_fig2 <- round(arklab_physeq.ord2$values$Eigenvalues[1] / sum(arklab_physeq.ord2$values$Eigenvalues) * 100, 2)
evals2_fig2 <- round(arklab_physeq.ord2$values$Eigenvalues[2] / sum(arklab_physeq.ord2$values$Eigenvalues) * 100, 2)

p2_fig2 <- ggplot(arklab_physeq.ordip2, aes(x = Axis.1, y = Axis.2)) +
  geom_point(colour="black",size=2, alpha= 0.8, shape=21, stroke=0.75,
             aes(fill=factor(Region)))+
  scale_fill_manual("Region", values = subject_cols)  +
  xlab(paste("PCoA 1 (", evals1_fig2, "%)", sep = "")) +
  ylab(paste("PCoA 2 (", evals2_fig2, "%)", sep = "")) +
  theme_bw() +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  )+
  ggtitle("figure2_pcoa_unweighted_unifrac")
print(p2_fig2)

########################################################################
###### figure2_2_NMDS_unweighted_unifrac
arklab_physeq.ord2_2 <- ordinate(arklab_physeq.gut.rel, "NMDS",  distance = "uunifrac")
arklab_physeq.ordip2_2 <- plot_ordination(arklab_physeq.gut.rel, arklab_physeq.ord2_2, justDF = T)
evals1_fig2_2 <- round(arklab_physeq.ord2_2$values$Eigenvalues[1] / sum(arklab_physeq.ord2_2$values$Eigenvalues) * 100, 2)
evals2_fig2_2 <- round(arklab_physeq.ord2_2$values$Eigenvalues[2] / sum(arklab_physeq.ord2_2$values$Eigenvalues) * 100, 2)
arklab_physeq.ordip2_2

p_fig2_2 <- ggplot(arklab_physeq.ordip2_2, aes(x = NMDS1, y = NMDS2)) +
  geom_point(colour="black",size=2, alpha= 0.8, shape=21, stroke=0.75,
             aes(fill=factor(Region)))+
  scale_fill_manual("Region", values = subject_cols)  +
  xlab(paste("PCoA 1 (", evals1_fig2_2, "%)", sep = "")) +
  ylab(paste("PCoA 2 (", evals2_fig2_2, "%)", sep = "")) +
  theme_bw() +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  )+
  ggtitle("figure2_2_nmds_unweighted_unifrac")
print(p_fig2_2)

########################################################################
###### figure2_3_MDS_unweighted_unifrac
arklab_physeq.ord2_3 <- ordinate(arklab_physeq.gut.rel, "MDS",  distance = "uunifrac")
arklab_physeq.ordip2_3 <- plot_ordination(arklab_physeq.gut.rel, arklab_physeq.ord2_3, justDF = T)
evals1_fig2_3 <- round(arklab_physeq.ord2_3$values$Eigenvalues[1] / sum(arklab_physeq.ord2_3$values$Eigenvalues) * 100, 2)
evals2_fig2_3 <- round(arklab_physeq.ord2_3$values$Eigenvalues[2] / sum(arklab_physeq.ord2_3$values$Eigenvalues) * 100, 2)
arklab_physeq.ordip2_3

p_fig2_3 <- ggplot(arklab_physeq.ordip3, aes(x = Axis.1, y = Axis.2)) +
  geom_point(colour="black",size=2, alpha= 0.8, shape=21, stroke=0.75,
             aes(fill=factor(Region)))+
  scale_fill_manual("Region", values = subject_cols)  +
  xlab(paste("PCoA 1 (", evals1_fig2_3, "%)", sep = "")) +
  ylab(paste("PCoA 2 (", evals2_fig2_3, "%)", sep = "")) +
  theme_bw() +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  )+
  ggtitle("figure2_3_MDS_unweighted_unifrac")
print(p_fig2_3)

########################################################################
###### figure3_pcoa_weighted_unifrac
arklab_physeq.ord3 <- ordinate(arklab_physeq.gut.rel, "PCoA",  distance = "wunifrac")
arklab_physeq.ordip3 <- plot_ordination(arklab_physeq.gut.rel, arklab_physeq.ord3, justDF = T)

evals1_fig3 <- round(arklab_physeq.ord3$values$Eigenvalues[1] / sum(arklab_physeq.ord3$values$Eigenvalues) * 100, 2)
evals2_fig3 <- round(arklab_physeq.ord3$values$Eigenvalues[2] / sum(arklab_physeq.ord3$values$Eigenvalues) * 100, 2)

p_fig3 <- ggplot(arklab_physeq.ordip3, aes(x = Axis.1, y = Axis.2)) +
  geom_point(colour="black",size=2, alpha= 0.8, shape=21, stroke=0.75,
             aes(fill=factor(Region)))+
  scale_fill_manual("Region", values = subject_cols)  +
  xlab(paste("PCoA 1 (", evals1_fig3, "%)", sep = "")) +
  ylab(paste("PCoA 2 (", evals2_fig3, "%)", sep = "")) +
  theme_bw() +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  )+
  ggtitle("figure3_pcoa_weighted_unifrac")
print(p_fig3)

########################################################################
###### figure3_2_nmds_weighted_unifrac
arklab_physeq.ord3_2 <- ordinate(arklab_physeq.gut.rel, "NMDS",  distance = "wunifrac")
arklab_physeq.ordip3_2 <- plot_ordination(arklab_physeq.gut.rel, arklab_physeq.ord3_2, justDF = T)

evals1_fig3_2 <- round(arklab_physeq.ord3_2$values$Eigenvalues[1] / sum(arklab_physeq.ord3_2$values$Eigenvalues) * 100, 2)
evals2_fig3_2 <- round(arklab_physeq.ord3_2$values$Eigenvalues[2] / sum(arklab_physeq.ord3_2$values$Eigenvalues) * 100, 2)
arklab_physeq.ord3_2
arklab_physeq.ordip3_2
# 혹시나 Axis.1 not found 에러 나오면 ggplot에서 aes(x= "", y="") 이 부분과 arklab_physeq.ordip3_2에 나오는 두 축 이름이 동일한지 확인해볼 것 
p_fig3_2 <- ggplot(arklab_physeq.ordip3_2, aes(x = NMDS1, y = NMDS2)) +
  geom_point(colour="black",size=2, alpha= 0.8, shape=21, stroke=0.75,
             aes(fill=factor(Region)))+
  scale_fill_manual("Region", values = subject_cols)  +
  xlab(paste("PCoA 1 (", evals1_fig3, "%)", sep = "")) +
  ylab(paste("PCoA 2 (", evals2_fig3, "%)", sep = "")) +
  theme_bw() +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  )+
  ggtitle("figure3_2_nmds_weighted_unifrac")
print(p_fig3_2)
