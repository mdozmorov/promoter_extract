use hg19ucsc;
select chrom,txstart,txend,name2,".",strand from refgene
where chrom in ('chr1','chr2','chr3','chr4','chr5','chr6','chr7','chrX','chr8','chr9','chr10','chr11','chr12','chr13','chr14','chr15','chr16','chr17','chr18','chr20','chrY','chr19','chr22','chr21','chrM')
AND name2 in ('FSTL3','HNRNPAB','C12orf71','MIR548AR','NME6','ELMO2','PGBD5','PRPF19','RALBP1','NBPF10') into outfile "111.txt";
