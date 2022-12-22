# PICRUSt2 pipeline
# Last updated: 221222
# By: LTY

conda activate qiime2-2022.8

qiime tools export --input-path rep-seqs_4.qza  --output-path exported-seqs-table

qiime tools export --input-path rep-seqs_4.qza --output-path exported-seqs-table

cp dna-sequences.fasta -o dna-sequences.fna

qiime tools export --input-path table_4.qza --output-path exported-feature-table2

# [note] biom command works only when qiime2 is activated
biom head -i feature-table.biom

# get more information
biom summarize-table -i feature-table.biom

# step 1. Place reads into reference tree
## filename: 1_phylogenetictee_with_ASV.sh

vi 1_phylogenetictee_with_ASV.sh

# 파일 생성후 실행 가능파일로 권한 바꿔줄 것
chmod +x 1_phylogenetictee_with_ASV.sh

place_seqs.py -s ../exported-seqs-table/dna-sequences.fna -o out.tre -p 16 \
              --intermediate intermediate/place_seqs




