## Import F_1 Files
## 1. import fastfiles in manifest format
qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path F_1_metadata.tsv \
  --output-path ./F_1/F_1_demux_seqs.qza \
  --input-format PairedEndFastqManifestPhred33V2

## 2. visualize demux_seqs
qiime demux summarize \
  --i-data ./F_1/F_1_demux_seqs.qza \
  --o-visualization ./F_1/F_1_demux_seqs.qzv

## 3. quality control
qiime dada2 denoise-paired \
  --i-demultiplexed-seqs ./F_1/F_1_demux_seqs.qza \
  --p-trunc-len-f 130 \
  --p-trunc-len-r 130 \
  --o-table ./F_1/F_1_table.qza \
  --o-representative-sequences ./F_1/F_1_rep-seqs.qza \
  --o-denoising-stats ./F_1/F_1_denoising-stats.qza \
  --p-n-threads 16

## 4. summarize
qiime feature-table summarize \
  --i-table ./F_1/F_1_table.qza \
  --o-visualization ./F_1/F_1_table.qzv \
  --m-sample-metadata-file F_1_metadata.tsv

qiime feature-table tabulate-seqs \
  --i-data ./F_1/F_1_rep-seqs.qza \
  --o-visualization ./F_1/F_1_rep-seqs.qzv

qiime metadata tabulate \
  --m-input-file ./F_1/F_1_denoising-stats.qza \
  --o-visualization ./F_1/F_1_denoising-stats.qzv

## 5. classify_sklearn
qiime feature-classifier classify-sklearn \
  --i-classifier /NAS/home/tylee/2022/DADA2/silva-138-99-515-806-nb-classifier.qza \
  --i-reads ./F_1/F_1_rep-seqs.qza \
  --o-classification ./F_1/F_1_taxonomy.qza

qiime metadata tabulate \
  --m-input-file ./F_1/F_1_taxonomy.qza \
  --o-visualization ./F_1/F_1_taxonomy.qzv
(qiime2-2022.2) tylee@ark2:~/2022/221122_ValidateToyData$ cat vim 1_F_1.sh
cat: vim: 그런 파일이나 디렉터리가 없습니다
## Import F_1 Files
## 1. import fastfiles in manifest format
qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path F_1_metadata.tsv \
  --output-path ./F_1/F_1_demux_seqs.qza \
  --input-format PairedEndFastqManifestPhred33V2

## 2. visualize demux_seqs
qiime demux summarize \
  --i-data ./F_1/F_1_demux_seqs.qza \
  --o-visualization ./F_1/F_1_demux_seqs.qzv

## 3. quality control
qiime dada2 denoise-paired \
  --i-demultiplexed-seqs ./F_1/F_1_demux_seqs.qza \
  --p-trunc-len-f 150 \
  --p-trunc-len-r 150 \
  --o-table ./F_1/F_1_table.qza \
  --o-representative-sequences ./F_1/F_1_rep-seqs.qza \
  --o-denoising-stats ./F_1/F_1_denoising-stats.qza \
  --p-n-threads 16

## 4. summarize
qiime feature-table summarize \
  --i-table ./F_1/F_1_table.qza \
  --o-visualization ./F_1/F_1_table.qzv \
  --m-sample-metadata-file F_1_metadata.tsv

qiime feature-table tabulate-seqs \
  --i-data ./F_1/F_1_rep-seqs.qza \
  --o-visualization ./F_1/F_1_rep-seqs.qzv

qiime metadata tabulate \
  --m-input-file ./F_1/F_1_denoising-stats.qza \
  --o-visualization ./F_1/F_1_denoising-stats.qzv

## 5. classify_sklearn
qiime feature-classifier classify-sklearn \
  --i-classifier /NAS/home/tylee/2022/DADA2/silva-138-99-515-806-nb-classifier.qza \
  --i-reads ./F_1/F_1_rep-seqs.qza \
  --o-classification ./F_1/F_1_taxonomy.qza

qiime metadata tabulate \
  --m-input-file ./F_1/F_1_taxonomy.qza \
  --o-visualization ./F_1/F_1_taxonomy.qzv
