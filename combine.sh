#!/usr/bin/env bash

output_file="output/combined_full.csv"

echo "sample,tax,taxid,rel_abundance" > ${output_file}

for tax in F G O S; do 
    echo ${tax}
    while read f; do
        sample=$(basename ${f} | sed "s/\.fastq_${tax}\.csv//g")
        tail -n +2 ${f} | sed "s/^/${sample},${tax},/g" >> ${output_file}
    done< <(find output/20220909_1017_X1_FAT84254_e5238139_full/ -name "*.fastq_${tax}.csv" | sort)
done
