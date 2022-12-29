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

# activate picrust2
conda activate picrust2

# step 1. Place reads into reference tree
## filename: 1_phylogenetictee_with_ASV.sh

vi 1_phylogenetictee_with_ASV.sh

# 파일 생성후 실행 가능파일로 권한 바꿔줄 것
# 이 step 이후에 만드는 파일들에 대해서도 모두 권한을 바꿔줄 것
chmod +x 1_phylogenetictee_with_ASV.sh

# 파일에 다음 코드 추가
place_seqs.py -s ../exported-seqs-table/dna-sequences.fna -o out.tre -p 16 \
              --intermediate intermediate/place_seqs
# 파일을 실행할때는 ./파일이름 으로 하면된다

./1_phylogenetictee_with_ASV.sh

# step 2. Hidden-state prediction of gene families
## filename: 2_gene_prediction.sh

hsp.py -i 16S -t out.tre -o marker_predicted_and_nsti.tsv.gz -p 16 -n
hsp.py -i EC -t out.tre -o EC_predicted.tsv.gz -p 16

# take a look at each file
zless -S marker_predicted_and_nsti.tsv.gz
zless -S EC_predicted.tsv.gz

# step 3. Generate metagenome predictions
## filename: 3_metagenome_prediction.sh

metagenome_pipeline.py -i ../feature-table.biom -m marker_predicted_and_nsti.tsv.gz -f EC_predicted.tsv.gz \
                       -o EC_metagenome_out --strat_out

## (optional) generate this file in legacy format for programs like BURRITO and MIMOSA

convert_table.py EC_metagenome_out/pred_metagenome_contrib.tsv.gz \
                 -c contrib_to_legacy \
                 -o EC_metagenome_out/pred_metagenome_contrib.legacy.tsv.gz

# step 4. Pathway-level inference
## filename: 4_pathway_inference.sh

pathway_pipeline.py -i EC_metagenome_out/pred_metagenome_unstrat.tsv.gz \
                    -o pathways_out -p 16

# step 5. Add functional descriptions
## filename: 5_add_functional_description.sh

add_descriptions.py -i EC_metagenome_out/pred_metagenome_unstrat.tsv.gz -m EC \
                    -o EC_metagenome_out/pred_metagenome_unstrat_descrip.tsv.gz

add_descriptions.py -i pathways_out/path_abun_unstrat.tsv.gz -m METACYC \
                    -o pathways_out/path_abun_unstrat_descrip.tsv.gz

