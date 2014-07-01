use hg19ucsc;
SELECT chrom AS 'Chrom',txstart-2000 AS 'txStart',txstart AS 'txEnd',name2 AS 'Name',strand AS 'Strand' FROM refGene WHERE name2 IN (
'ATG5','BANK1','BLK','CD226','ETS1','FCGR2A','ICA1','IFIH1','IKZF1','IKZF3','IL10','IL2','IL21','IRAK1','IRF5','IRF7','IRF8','ITGAM','JAZF1','MECP2','MIR146A','NCF2','PDCD1','PRDM1','PTPN22','RPP14','STAT4','TNFAIP3','TNFSF4','TNIP1','TYK2','UBE2L3','UHRF1BP1','WDFY4'
) AND strand='+' 
AND chrom in ('chr1','chr2','chr3','chr4','chr5','chr6','chr7','chrX','chr8','chr9','chr10','chr11','chr12','chr13','chr14','chr15','chr16','chr17','chr18','chr20','chrY','chr19','chr22','chr21','chrM')
GROUP BY txStart into outfile "333.txt";
SELECT chrom AS 'Chrom',txend AS 'txStart',txend+2000 AS 'txEnd',name2 AS 'Name',strand AS 'Strand' FROM refGene WHERE name2 IN (
'ATG5','BANK1','BLK','CD226','ETS1','FCGR2A','ICA1','IFIH1','IKZF1','IKZF3','IL10','IL2','IL21','IRAK1','IRF5','IRF7','IRF8','ITGAM','JAZF1','MECP2','MIR146A','NCF2','PDCD1','PRDM1','PTPN22','RPP14','STAT4','TNFAIP3','TNFSF4','TNIP1','TYK2','UBE2L3','UHRF1BP1','WDFY4'
) AND strand='-' 
AND chrom in ('chr1','chr2','chr3','chr4','chr5','chr6','chr7','chrX','chr8','chr9','chr10','chr11','chr12','chr13','chr14','chr15','chr16','chr17','chr18','chr20','chrY','chr19','chr22','chr21','chrM')
GROUP BY txEnd into outfile "444.txt";
