# Promoter extract 

Extract promoter regions for a list of genes in [.BED format](http://genome.ucsc.edu/FAQ/FAQformat.html) from the UCSC genome database. Promoters are defined as 2,000 bases upstream of a gene's transcription start site (TSS). 

Note each gene may have different isoforms = different TSSs. The pipeline extracts the promoters for each isoform, and merges overlapping into a single promoter.

## Requirements
Linux environment
[Perl](http://www.perl.org)
[BedTools](https://code.google.com/p/bedtools)

## Usage

Create a text file with a list of official gene names. Examples are in 'txt' folder.

Run:
    perl refgene.pl <file> <db_name> | sort -k1,1 -k2,2n -k3,3n | mergeBed -s -i -

The first command (**perl refgene.pl**) will extract the promoters of all genes/isoforms from a text <file> for an organism specified by <db> in [.BED format](http://genome.ucsc.edu/FAQ/FAQformat.html). **sort** command will sort them by chromosome, then start, then end coordinated. **mergeBed** will collapse overlapping promoters into a single interval, considering strand-specific promoters.

## Output

**\*_not_found.txt** file has gene names not found in the UCSC database. It is advised to look up them in [GeneCards](http://www.genecards.org/), update gene names and re-run the script.

Genomic coordinates are printed into standard output; redirect into any file.

## Example

    perl refgene.pl txt/sle.txt hg19 | sort -k1,1 -k2,2n -k3,3n | mergeBed -s -i - > sle.txt.bed

This would extract genomic coordinates of the promoters of genes associated with Systemic Lupus Erythematosus.

## Citation

If you find this script useful, please, cite:
Dozmorov MG, Cara LR, Giles CB, Wren JD. GenomeRunner: automating genome
exploration. Bioinformatics. 2012 Feb 1;28(3):419-20. doi:
10.1093/bioinformatics/btr666. Epub 2011 Dec 6. PubMed PMID: 22155868; PubMed
Central PMCID: PMC3268239.

## License and Disclaimer
refgene.pl is written by Krista Bean
(C) Mikhail Dozmorov, Krista Bean  2013, Academic Free License ("AFL") v. 3.0