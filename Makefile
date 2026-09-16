
SHELL = /bin/bash

DB_URL = https://ftp.ncbi.nlm.nih.gov/blast/db/16S_ribosomal_RNA.tar.gz
TAXDB_URL = https://ftp.ncbi.nlm.nih.gov/blast/db/taxdb.tar.gz

db/taxdb:
	mkdir -p db/taxdb && wget ${TAXDB_URL} && \
	tar -xzvf taxdb.tar.gz -C db/taxdb && rm taxdb.tar.gz
db: db/taxdb
	wget ${DB_URL} && tar -xzvf 16S_ribosomal_RNA.tar.gz -C db && \
	rm 16S_ribosomal_RNA.tar.gz 

