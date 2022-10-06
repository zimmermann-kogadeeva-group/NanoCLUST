#!/usr/bin/env bash
#SBATCH -p htc-el8
#SBATCH -t 1-00:00:00
#SBATCH --mem 32G
#SBATCH -N1
#SBATCH -c16

eval "$(conda shell.bash hook)"
conda activate test_nanoclust

data_dir="data/20220909_1017_X1_FAT84254_e5238139/fastq_pass/"
output_dir="output/20220909_1017_X1_FAT84254_e5238139_full2/"

for f in ${data_dir}*.fastq.gz; do 
    echo ${f}
    nextflow run main.nf -profile conda --polishing_reads 130000 \
        --reads "${f}" --db 'db/16S_ribosomal_RNA' --tax "db/taxdb" \
        --outdir "${output_dir}$(basename ${f} | sed -e 's/\.fastq\.gz//')"
done

