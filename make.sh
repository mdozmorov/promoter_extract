# Get full list of gene names from HGNC
wget ftp://ftp.ebi.ac.uk/pub/databases/genenames/new/tsv/hgnc_complete_set.txt
gzip hgnc_complete_set.txt
mv gnc_complete_set.txt.gz txt/
# List of gene names
zcat < txt/hgnc_complete_set.txt.gz | sed '1d' | cut -f2 > txt/all.hgnc_symbol.txt
python refgene2.py txt/all.hgnc_symbol.txt | bedtools sort -i - | mergeBed -s -c 4 -o distinct -i - > all.hgnc_symbol.bed
