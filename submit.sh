#!/usr/bin/env bash
#SBATCH -p htc-el8
#SBATCH -t 1-00:00:00
#SBATCH --mem 32G
#SBATCH -N1
#SBATCH -c16

eval "$(conda shell.bash hook)"
conda activate test_nanoclust

data_dir="${1}/"
output_dir="${2:-output/test/}"

echo "Data dir: ${data_dir}" 
echo "Output dir: ${output_dir}"

for f in ${data_dir}*.fastq.gz; do 
    echo ${f}
    nextflow run main.nf -profile conda \
        --umap_set_size 130000 --cluster_sel_epsilon 0.25 --min_cluster_size 50 \
        --reads "${f}" --db "db/16S_ribosomal_RNA" --tax "db/taxdb" \
        --outdir "${output_dir}$(basename ${f} | sed -e 's/\.fastq\.gz//')"
done

