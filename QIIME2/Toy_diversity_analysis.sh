## 1. import fastfiles in manifest format
## Toy_LTY_1_2_import.sh
qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path Toy_LTY_metadata.tsv \
  --output-path ./Toy_LTY/demux_seqs.qza \
  --input-format PairedEndFastqManifestPhred33V2

## 2. visualize demux_seqs

qiime demux summarize \
  --i-data ./Toy_LTY/demux_seqs.qza \
  --o-visualization ./Toy_LTY/demux_seqs.qzv

## 3. quality control
## Toy_LTY_3_4_qualitycontrol.sh
qiime dada2 denoise-paired \
  --i-demultiplexed-seqs ./Toy_LTY/demux_seqs.qza \
  --p-trunc-len-f 150 \
  --p-trunc-len-r 150 \
  --o-table ./Toy_LTY/table.qza \
  --o-representative-sequences ./Toy_LTY/rep-seqs.qza \
  --o-denoising-stats ./Toy_LTY/denoising-stats.qza \
  --p-n-threads 16

## 4. summarize
qiime feature-table summarize \
  --i-table ./Toy_LTY/table.qza \
  --o-visualization ./Toy_LTY/table.qzv \
  --m-sample-metadata-file Toy_LTY_metadata.tsv

qiime feature-table tabulate-seqs \
  --i-data ./Toy_LTY/rep-seqs.qza \
  --o-visualization ./Toy_LTY/rep-seqs.qzv

qiime metadata tabulate \
  --m-input-file ./Toy_LTY/denoising-stats.qza \
  --o-visualization ./Toy_LTY/denoising-stats.qzv


## 5. phylogenetic tree
## Toy_LTY_5_phytree.sh

qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences ./Toy_LTY/rep-seqs.qza \
  --o-alignment ./Toy_LTY/aligned-rep-seqs.qza \
  --o-masked-alignment ./Toy_LTY/masked-aligned-rep-seqs.qza \
  --o-tree ./Toy_LTY/unrooted-tree.qza \
  --o-rooted-tree ./Toy_LTY/rooted-tree.qza


## 6. diversity analysis
## Toy_LTY_6_diversity.sh
## used median value(100) of samples referring to "table.qzv" data
## sampling value depth is important, 'Moving Pictures' tutorial bases this value using table.qzv
qiime diversity core-metrics-phylogenetic \
  --i-phylogeny ./Toy_LTY/rooted-tree.qza \
  --i-table ./Toy_LTY/table.qza \
  --p-sampling-depth 100 \
  --m-metadata-file Toy_LTY_metadata.tsv \
  --output-dir ./Toy_LTY/core-metrics-results

## 7. alpha diversity analysis
## Toy_LTY_7_8_9_alpha_beta_diversity_visualization.sh
qiime diversity alpha-group-significance \
  --i-alpha-diversity ./Toy_LTY/core-metrics-results/faith_pd_vector.qza \
  --m-metadata-file Toy_LTY_metadata.tsv \
  --o-visualization ./Toy_LTY/core-metrics-results/faith-pd-group-significance.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity ./Toy_LTY/core-metrics-results/evenness_vector.qza \
  --m-metadata-file Toy_LTY_metadata.tsv \
  --o-visualization ./Toy_LTY/core-metrics-results/evenness-group-significance.qzv

qiime diversity alpha \
  --i-table ./Toy_LTY/table.qza \
  --p-metric chao1 \
  --o-alpha-diversity ./Toy_LTY/core-metrics-results/chao1_vector.qza

qiime diversity alpha-group-significance \
 --i-alpha-diversity ./Toy_LTY/core-metrics-results/chao1_vector.qza \
 --m-metadata-file Toy_LTY_metadata.tsv \
 --o-visualization ./Toy_LTY/core-metrics-results/chao1_statistics.qzv

## 8. beta diversity analysis
## Toy_LTY_8_beta_diversity.sh
qiime diversity beta-group-significance \
  --i-distance-matrix ./Toy_LTY/core-metrics-results/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file Toy_LTY_metadata.tsv \
  --m-metadata-column group \
  --o-visualization ./Toy_LTY/core-metrics-results/unweighted-unifrac-body-site-significance.qzv \
  --p-pairwise

qiime diversity beta-group-significance \
  --i-distance-matrix ./Toy_LTY/core-metrics-results/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file Toy_LTY_metadata.tsv \
  --m-metadata-column group \
  --o-visualization ./Toy_LTY/core-metrics-results/unweighted-unifrac-subject-group-significance.qzv \
  --p-pairwise

## 9. beta diversity visualization
## Toy_LTY_9_beta_diversity_visualization.sh
qiime emperor plot \
  --i-pcoa ./Toy_LTY/core-metrics-results/unweighted_unifrac_pcoa_results.qza \
  --m-metadata-file Toy_LTY_metadata.tsv \
  --o-visualization ./Toy_LTY/core-metrics-results/unweighted-unifrac.qzv

qiime emperor plot \
  --i-pcoa ./Toy_LTY/core-metrics-results/bray_curtis_pcoa_results.qza \
  --m-metadata-file Toy_LTY_metadata.tsv \
  --o-visualization ./Toy_LTY/core-metrics-results/bray-curtis.qzv



## 10. alphararefaction
## ERROR!!!
## Toy_LTY_10_alphararefaction.sh

qiime diversity alpha-rarefaction \
  --i-table ./Toy_LTY/table.qza \
  --i-phylogeny ./Toy_LTY/rooted-tree.qza \
  --p-max-depth 5 \
  --m-metadata-file Toy_LTY_metadata_diversity.tsv \
  --o-visualization ./Toy_LTY/alpha-rarefaction.qzv


## 11. taxonomic analysis
## Toy_LTY_11_taxonomy.sh
qiime feature-classifier classify-sklearn \
  --i-classifier /NAS/home/tylee/2022/DADA2/silva-138-99-515-806-nb-classifier.qza \
  --i-reads ./Toy_LTY/rep-seqs.qza \
  --o-classification ./Toy_LTY/taxonomy.qza

qiime metadata tabulate \
  --m-input-file ./Toy_LTY/taxonomy.qza \
  --o-visualization ./Toy_LTY/taxonomy.qzv

qiime taxa barplot \
  --i-table ./Toy_LTY/table.qza \
  --i-taxonomy ./Toy_LTY/taxonomy.qza \
  --m-metadata-file Toy_LTY_metadata.tsv \
  --o-visualization ./Toy_LTY/taxa-bar-plots.qzv
