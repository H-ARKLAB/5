## Import E_1 Files
## 1. import fastfiles in manifest format
qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path E_1_metadata.tsv \
  --output-path ./E_1/E_1_demux_seqs.qza \
  --input-format PairedEndFastqManifestPhred33V2

## 2. visualize demux_seqs
qiime demux summarize \
  --i-data ./E_1/E_1_demux_seqs.qza \
  --o-visualization ./E_1/E_1_demux_seqs.qzv

## 3. quality control
qiime dada2 denoise-paired \
  --i-demultiplexed-seqs ./E_1/E_1_demux_seqs.qza \
  --p-trunc-len-f 200 \
  --p-trunc-len-r 200 \
  --o-table ./E_1/E_1_table.qza \
  --o-representative-sequences ./E_1/E_1_rep-seqs.qza \
  --o-denoising-stats ./E_1/E_1_denoising-stats.qza \
  --p-n-threads 16

## 4. summarize
qiime feature-table summarize \
  --i-table ./E_1/E_1_table.qza \
  --o-visualization ./E_1/E_1_table.qzv \
  --m-sample-metadata-file E_1_metadata.tsv

qiime feature-table tabulate-seqs \
  --i-data ./E_1/E_1_rep-seqs.qza \
  --o-visualization ./E_1/E_1_rep-seqs.qzv

qiime metadata tabulate \
  --m-input-file ./E_1/E_1_denoising-stats.qza \
  --o-visualization ./E_1/E_1_denoising-stats.qzv

## 5. classify_sklearn
qiime feature-classifier classify-sklearn \
  --i-classifier /NAS/home/tylee/2022/DADA2/silva-138-99-515-806-nb-classifier.qza \
  --i-reads ./E_1/E_1_rep-seqs.qza \
  --o-classification ./E_1/E_1_taxonomy.qza

qiime metadata tabulate \
  --m-input-file ./E_1/E_1_taxonomy.qza \
  --o-visualization ./E_1/E_1_taxonomy.qzv
