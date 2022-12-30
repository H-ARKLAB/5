# STAMP EC (Enzyme classification number) pipeline
# First written: 221229
# By: LTY

# move to working directory
/NAS/home/ygkang/Downloads/Garcinia_221212/HDS_set2/Output/PICRUST2_LTY/EC_metagenome_out

# 그룹에 대한 정규표현식은 다음처럼 변환해서 사용
# LFD: /LFD[12345]/
# HFD: /HFD[12345]/
# H: /-H[12345]/
# G: /-G[12345]/
# HG: /-HG[12345]/

# 압축이 풀린 "pred_metagenome_contrib_1.tsv" 파일 사용
# EC 번호도 변환해서 사용 (여기는 예시로만 적혀있음)

# 각 그룹당 몇개의 행이 출력되는지 확인하고 싶다면

awk -e '$1 ~ /LFD[12345]/ {print $0}'  pred_metagenome_contrib_1.tsv | grep -w "EC:1.2.7.1"| wc -l

# 열의 총 합을 구하고 싶다면
# $4 ~ $9 열이 뭔지는 tsv 파일에서 확인 할 것
awk -e '$1 ~ /LFD[12345]/ {print $0}'  pred_metagenome_contrib_1.tsv | grep -w "EC:1.2.7.1"| awk '{sum+=$9} END {print sum}'
