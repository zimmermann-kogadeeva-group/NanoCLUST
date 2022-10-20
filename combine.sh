#!/usr/bin/env bash

input_dir="${1}"
output_file="${2:-test.csv}"

echo "sample,tax,taxid,rel_abundance" > ${output_file}

for tax in F G O S; do 
    echo ${tax}
    while read f; do
        sample=$(basename ${f} | sed "s/\.fastq_${tax}\.csv//g")
        tail -n +2 ${f} | sed "s/^/${sample},${tax},/g" >> ${output_file}
    done< <(find ${input_dir} -name "*.fastq_${tax}.csv" | sort)
done
