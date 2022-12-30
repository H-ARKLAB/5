# Chen2021 data qiime2 analysis 명령어 모음
# mouse data for ABKefir diet, n=6 for each group
# Last updated:: 221230
# By: LTY

#Chen2021 data QIIME2 command list

#0_download_reference_db.sh 
# download reference database for OTU table construction
#1. Closed-reference clustering
#1) Download the Greengenes database v.13.5:
wget ftp://greengenes.microbio.me/greengenes_release/gg_13_5/gg_13_5_otus.tar.gz # download DB

tar -xvzf gg_13_5_otus.tar.gz # uncompress DB

qiime tools import --type 'FeatureData[Sequence]' --input-path gg_13_5_otus/rep_set/97_otus.fasta --output-path 97_otus-GG.qza # import fasta seqs

qiime tools import --type 'FeatureData[Taxonomy]' --input-format HeaderlessTSVTaxonomyFormat --input-path gg_13_5_otus/taxonomy/97_otu_taxonomy.txt --output-path 97_otu-ref-taxonomy-GG.qza # import taxonomy

#2) Do the OTU clustering at 97%
qiime vsearch cluster-features-closed-reference --i-table table-dada2.qza --i-sequences rep-seqs-dada2.qza --i-reference-sequences 97_otus-GG.qza --p-perc-identity 0.97 --o-clustered-table tbl-cr-97.qza --o-clustered-sequences rep-seqs-cr-97.qza --o-unmatched-sequences unmatched-cr-97.qza

#3) Export the OTU table
qiime tools export --input-path tbl-cr-97.qza --output-path exported-feature-table

#Now you have your table in biom format - feature-table.biom (the OTU table in biom format!).

#1_import.sh
# make sure manifest file contains correct absolute-filepath
# 질문 is this input format okay?
qiime tools import \
  --type 'SampleData[SequencesWithQuality]' \
  --input-path Chenmanifest_cd_hfd_hfabk.tsv \
  --output-path demux_seqs.qza \
  --input-format SingleEndFastqManifestPhred33V2

#2_summarize.sh
# Check the quality of sequences
qiime demux summarize \
  --i-data ./demux_seqs.qza \
  --o-visualization ./demux_seqs.qzv

#3_qualitycontrol.sh
# sequence quality control and feature table construction using DADA2
qiime dada2 denoise-single \
  --i-demultiplexed-seqs ./demux_seqs.qza \
  --p-trunc-len 270 \
  --o-table ./dada2_table.qza \
  --o-representative-sequences ./dada2_rep_set.qza \
  --o-denoising-stats ./dada2_stats.qza

#4_tabulate.sh
qiime metadata tabulate \
  --m-input-file ./dada2_stats.qza  \
  --o-visualization ./dada2_stats.qzv

#5_summarize.sh
qiime feature-table summarize \
  --i-table ./dada2_table.qza \
  --m-sample-metadata-file ./Chenmanifest_cd_hfd_hfabk.tsv \
  --o-visualization ./dada2_table.qzv

#6_otu_clustering.sh
# make sure unzipped reference file 97_otus-GG.qza is in the correct directory
qiime vsearch cluster-features-closed-reference \
  --i-table dada2_table.qza \
  --i-sequences dada2_rep_set.qza \
  --i-reference-sequences ../97_otus-GG.qza \
  --p-perc-identity 0.97 \
  --o-clustered-table tbl-cr-97.qza \
  --o-clustered-sequences rep-seqs-cr-97.qza \
  --o-unmatched-sequences unmatched-cr-97.qza

#7_otu_exportfile.sh
qiime tools export --input-path tbl-cr-97.qza --output-path exported-feature-table

#8_phylogenetictree.sh
qiime fragment-insertion sepp \
  --i-representative-sequences ./dada2_rep_set.qza \
  --i-reference-database ../Chen/sepp-refs-gg-13-8.qza \
  --o-tree ./tree.qza \
  --o-placements ./tree_placements.qza \
  --p-threads 32  # update to a higher number if you can

#9_alpha_rarefaction.sh
qiime diversity alpha-rarefaction \
  --i-table ./dada2_table.qza \
  --m-metadata-file ./Chenmanifest_cd_hfd_hfabk.tsv \
  --o-visualization ./alpha_rarefaction_curves.qzv \
  --p-min-depth 10 \
  --p-max-depth 54255

#10_diversity_analysis.sh
qiime diversity core-metrics-phylogenetic \
  --i-table ./dada2_table.qza \
  --i-phylogeny ./tree.qza \
  --m-metadata-file ./Chenmanifest_cd_hfd_hfabk.tsv \
  --p-sampling-depth 25000 \
  --output-dir ./core-metrics-results

#11_alpha_diversity_faithpd.sh
qiime diversity alpha-group-significance \
  --i-alpha-diversity ./core-metrics-results/faith_pd_vector.qza \
  --m-metadata-file ./Chenmanifest_cd_hfd_hfabk.tsv \
  --o-visualization ./core-metrics-results/faiths_pd_statistics.qzv

#12_alpha_diversity_evenness.sh
qiime diversity alpha-group-significance \
 --i-alpha-diversity ./core-metrics-results/evenness_vector.qza \
 --m-metadata-file ./Chenmanifest_cd_hfd_hfabk.tsv \
 --o-visualization ./core-metrics-results/evenness_statistics.qzv

#13_alpha_diversity_chao1.sh
qiime diversity alpha \
  --i-table dada2_table.qza \
  --p-metric chao1 \
  --o-alpha-diversity ./core-metrics-results/chao1_vector.qza

qiime diversity alpha-group-significance \
 --i-alpha-diversity ./core-metrics-results/chao1_vector.qza \
 --m-metadata-file ./Chenmanifest_cd_hfd_hfabk.tsv \
 --o-visualization ./core-metrics-results/chao1_statistics.qzv


