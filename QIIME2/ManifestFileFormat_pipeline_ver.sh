conda activate qiime2-2022.2

## 0. move to working directory

## Import A_1 Files
## 1. import fastfiles in manifest format
qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path A_1_metadata.tsv \
  --output-path A_1_demux_seqs.qza \
  --input-format PairedEndFastqManifestPhred33V2

## 2. visualize demux_seqs
qiime demux summarize \
  --i-data ./A_1_demux_seqs.qza \
  --o-visualization ./A_1_demux_seqs.qzv
  
## 3. quality control --> doest not work
## error message: No reads passed the filter. trunc_len_f (200) or trunc_len_r (200) may be individually longer than read lengths,
## or trunc_len_f + trunc_len_r may be shorter than the length of the amplicon + 12 nucleotides (the length of the overlap).
## Alternatively, other arguments (such as max_ee or trunc_q) may be preventing reads from passing the filter.


## Import B_1 Files
## 1. import fastfiles in manifest format
qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path B_1_metadata.tsv \
  --output-path B_1_demux_seqs.qza \
  --input-format PairedEndFastqManifestPhred33V2

## 2. visualize demux_seqs
qiime demux summarize \
  --i-data ./B_1_demux_seqs.qza \
  --o-visualization ./B_1_demux_seqs.qzv

## 3. quality control
qiime dada2 denoise-paired \
  --i-demultiplexed-seqs B_1_demux_seqs.qza \
  --p-trunc-len-f 200 \
  --p-trunc-len-r 200 \
  --o-table B_1_table.qza \
  --o-representative-sequences B_1_rep-seqs.qza \
  --o-denoising-stats B_1_denoising-stats.qza \
  --p-n-threads 16
  
## 4. summarize
qiime feature-table summarize \
  --i-table B_1_table.qza \
  --o-visualization B_1_table.qzv \
  --m-sample-metadata-file B_1_metadata.tsv

qiime feature-table tabulate-seqs \
  --i-data B_1_rep-seqs.qza \
  --o-visualization B_1_rep-seqs.qzv

qiime metadata tabulate \
  --m-input-file B_1_denoising-stats.qza \
  --o-visualization B_1_denoising-stats.qzv

## 5. classify_sklearn

qiime feature-table summarize \
  --i-table table.qza \
  --o-visualization table.qzv \
  --m-sample-metadata-file dada2_metadata.tsv

qiime feature-table tabulate-seqs \
  --i-data rep-seqs.qza \
  --o-visualization rep-seqs.qzv

qiime metadata tabulate \
  --m-input-file denoising-stats.qza \
  --o-visualization denoising-stats.qzv

