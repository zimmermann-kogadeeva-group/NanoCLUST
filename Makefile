
SHELL = /bin/bash
ENV_NAME = test_nanoclust

REMOTE = embl
REMOTE_DIR = /g/mazimmer/bartmans/Projects/TestNanoCLUST/
SYNC_FLAGS = -av
SYNC = rsync

ifeq (,$(findstring cluster.embl.de,${HOSTNAME}))
	REMOTE_DIR := ${REMOTE}:${REMOTE_DIR}
endif

.PHONY: pull_% push_% pull push git_update install_precommit

DB_URL = https://ftp.ncbi.nlm.nih.gov/blast/db/16S_ribosomal_RNA.tar.gz
TAXDB_URL = https://ftp.ncbi.nlm.nih.gov/blast/db/taxdb.tar.gz

db/taxdb:
	mkdir -p db/taxdb && wget ${TAXDB_URL} && \
	tar -xzvf taxdb.tar.gz -C db/taxdb && rm taxdb.tar.gz
db: db/taxdb
	wget ${DB_URL} && tar -xzvf 16S_ribosomal_RNA.tar.gz -C db && \
	rm 16S_ribosomal_RNA.tar.gz 

pull_%:
	${SYNC} ${SYNC_FLAGS} ${REMOTE_DIR}$* ./

push_%: SYNC_FLAGS += --delete
push_%:
	${SYNC} ${SYNC_FLAGS} ./$* ${REMOTE_DIR}

pull: pull_data pull_output pull_notes.md
pull:
	echo $^

push: push_data push_output push_notes.md
push:
	echo $^

test_%: SYNC_FLAGS += -n
test_%: %
	echo $@

git_update:
	cd ${REMOTE_DIR} && git pull
		    
conda_env.yml:
	conda env export -n ${ENV_NAME} -f $@

conda_env_simple.yml: conda_env.yml
	conda env export -n ${ENV_NAME} -f $@ --from-history
	if grep -q "pip:" $^; then sed -i -e '$$d' $@ && sed -n -e '/pip:/,$$p' $^ >> $@; fi

.git/hooks/pre-commit:
	ln -s ../../.pre-commit $@

install_precommit: .git/hooks/pre-commit

