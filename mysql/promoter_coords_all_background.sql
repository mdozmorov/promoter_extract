use hg19ucsc;
SELECT chrom AS 'Chrom',txstart-2000 AS 'txStart',txstart AS 'txEnd',name2 AS 'Name',strand AS 'Strand' FROM refGene WHERE strand='+' 
AND chrom in ('chr1','chr2','chr3','chr4','chr5','chr6','chr7','chrX','chr8','chr9','chr10','chr11','chr12','chr13','chr14','chr15','chr16','chr17','chr18','chr20','chrY','chr19','chr22','chr21','chrM')
GROUP BY txStart into outfile "111.txt";
SELECT chrom AS 'Chrom',txend AS 'txStart',txend+2000 AS 'txEnd',name2 AS 'Name',strand AS 'Strand' FROM refGene WHERE strand='-' 
AND chrom in ('chr1','chr2','chr3','chr4','chr5','chr6','chr7','chrX','chr8','chr9','chr10','chr11','chr12','chr13','chr14','chr15','chr16','chr17','chr18','chr20','chrY','chr19','chr22','chr21','chrM')
GROUP BY txEnd into outfile "222.txt";
