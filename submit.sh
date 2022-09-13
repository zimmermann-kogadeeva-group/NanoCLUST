#!/usr/bin/env bash
#SBATCH -p htc-el8
#SBATCH -t 3-00:00:00
#SBATCH --mem 32G
#SBATCH -N1
#SBATCH -c16

eval "$(/home/bartmans/.miniconda3/bin/conda shell.bash hook)"
conda activate test_nanoclust

module load canu FastQC Java/1.8.0_112

data_dir="data/20220909_1017_X1_FAT84254_e5238139/fastq_pass/"
output_dir="output/20220909_1017_X1_FAT84254_e5238139/"

for f in $(find ${data_dir}  -name "*.fastq.gz"); do 
    nextflow run main.nf -profile conda \
        --reads "${f}" --db 'db/16S_ribosomal_RNA' --tax "db/taxdb" \
        --outdir "${output_dir}$(basename ${f} | tr -d '.fastq.gz')"
done

