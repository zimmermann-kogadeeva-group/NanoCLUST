
SHELL = /bin/bash

SHELL = /bin/bash
ENV_NAME = nanoclust
ACTIVATE = eval "$$(conda shell.bash hook)" && conda activate ${ENV_NAME}

REMOTE = embl
REMOTE_DIR = /g/mazimmer/bartmans/Projects/TestNanoCLUST/
SYNC_FLAGS = -av
SYNC = rsync

ifneq (,$(wildcard .exclude))
    SYNC_FLAGS += --exclude-from .exclude
endif

ifeq (,$(findstring cluster.embl.de,${HOSTNAME}))
    REMOTE_DIR := ${REMOTE}:${REMOTE_DIR}
endif

.PHONY: pull push %_test install_precommit \
		conda_env.yml conda_env_simple.yml

all: conda_env.yml conda_env_simple.yml

pull:
	${SYNC} ${SYNC_FLAGS} ${REMOTE_DIR}/ ./

push: SYNC_FLAGS += --delete
push:
	${SYNC} ${SYNC_FLAGS} ./ ${REMOTE_DIR}/

%_test: SYNC_FLAGS += -n
%_test: %
	echo $^ 

conda_env.yml:
	conda env export -n ${ENV_NAME} -f $@

conda_env_simple.yml: conda_env.yml
	conda env export -n ${ENV_NAME} -f $@ --from-history
	if grep -q "pip:" $^; then sed -i -e '$$d' $@ && sed -n -e '/pip:/,$$p' $^ >> $@; fi

.git/hooks/pre-commit:
	ln -s ../../.pre-commit $@

install_precommit: .git/hooks/pre-commit

# Data

DB_URL = https://ftp.ncbi.nlm.nih.gov/blast/db/16S_ribosomal_RNA.tar.gz
TAXDB_URL = https://ftp.ncbi.nlm.nih.gov/blast/db/taxdb.tar.gz

db/taxdb:
	mkdir -p db/taxdb && wget ${TAXDB_URL} && \
	tar -xzvf taxdb.tar.gz -C db/taxdb && rm taxdb.tar.gz
db: db/taxdb
	wget ${DB_URL} && tar -xzvf 16S_ribosomal_RNA.tar.gz -C db && \
	rm 16S_ribosomal_RNA.tar.gz 

