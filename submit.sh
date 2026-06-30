#!/usr/bin/env bash
#SBATCH -p htc-el8
#SBATCH -t 1-00:00:00
#SBATCH --mem 32G
#SBATCH -N1
#SBATCH -c16

if [ ! -f conda_env_simple.yml ]; then
    wget https://git.embl.org/grp-zimmermann-kogadeeva/NanoCLUST/-/raw/master/conda_env_simple.yml -O conda_env_simple.yml
fi

# Create the conda env with old version of nextflow
if [ ! -d .envs/nextflow ]; then
    conda env create -p ./.envs/nextflow -f conda_env_simple.yml
fi

# Activate the conda env created above
eval "$(conda shell.bash hook)"
conda activate .envs/nextflow

data_dir="${1}/"
output_dir="${2:-Output}"

echo "Data dir: ${data_dir}" 
echo "Output dir: ${output_dir}"

pipeline_loc="main.nf"
if [ ! -f main.nf ]; then
    if [ ! -d NanoCLUST ]; then
        git clone https://git.embl.org/grp-zimmermann-kogadeeva/NanoCLUST.git
    fi
    pipeline_loc="NanoCLUST/main.nf"
fi

for f in ${data_dir}*.fastq.gz; do 
    echo ${f}
    nextflow run -resume \
        ${pipeline_loc} \
        -profile conda \
        --umap_set_size 130000 \
        --cluster_sel_epsilon 0.25 \
        --min_cluster_size 50 \
        --reads "${f}" \
        --db "db/16S_ribosomal_RNA" \
        --tax "db/taxdb" \
        --outdir "${output_dir}/$(basename ${f} | sed -e 's/\.fastq\.gz//')"
done

