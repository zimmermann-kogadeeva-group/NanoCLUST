
SHELL = /bin/bash
ENV_NAME = test_nanoclust

REMOTE = embl
REMOTE_DIR = /g/mazimmer/bartmans/Projects/NanoCLUST/
SYNC_FLAGS = -av
SYNC = rsync

.PHONY: pull_% push_% pull push git_update install_precommit

ifeq (,$(findstring cluster.embl.de,${HOSTNAME}))
	REMOTE_DIR := ${REMOTE}:${REMOTE_DIR}
endif

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

