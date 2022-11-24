cp D_1_metadata.tsv E_1_metadata.tsv
sed -i 's/D_1/E_1/g' E_1_metadata.tsv

cp 1_D_1.sh 1_E_1.sh
sed -i 's/D_1/E_1/g' 1_E_1.sh

mkdir E_1
