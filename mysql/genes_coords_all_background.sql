use hg19ucsc;
select chrom,txstart,txend,name2,".",strand from refGene  
where chrom in ('chr1','chr2','chr3','chr4','chr5','chr6','chr7','chrX','chr8','chr9','chr10','chr11','chr12','chr13','chr14','chr15','chr16','chr17','chr18','chr20','chrY','chr19','chr22','chr21','chrM')
AND strand='+' group by txstart into outfile "111.txt";
select chrom,txstart,txend,name2,".",strand from refGene  
where chrom in ('chr1','chr2','chr3','chr4','chr5','chr6','chr7','chrX','chr8','chr9','chr10','chr11','chr12','chr13','chr14','chr15','chr16','chr17','chr18','chr20','chrY','chr19','chr22','chr21','chrM')
AND strand='-' group by txend into outfile "222.txt";