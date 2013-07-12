#!/usr/bin/env perl

#usage: perl refgene.pl [input file with list of genes] [ucsc refGene database to use]
#example: perl refgene.pl [input file with gene list] hg19 | sort -k1,1 -k2,2n -k3,3n | mergeBed -s -nms -i - >[output bed file]

use DBI;
use DBD::mysql;

$inputfile = $ARGV[0];
$database = $ARGV[1];

#print "Input file: $inputfile\n";
#print "Datbase: $database\n";

open GENEFILE, "$inputfile" or die "Cannot open gene file.\n";

@genes = <GENEFILE>;

chomp(@genes);

$genelist = "";

$genesize = @genes;

#print "Number of Genes: $genesize\n";

for($i = 0; $i < $genesize; $i++)
{
	$tempgene = $genes[$i];
	$genelist = $genelist."'$tempgene'";
	if(($i+1) < $genesize)
	{
		$genelist = $genelist.",";
	}
}

$chrmlist = "'chr1','chr2','chr3','chr4','chr5','chr6','chr7','chrX','chr8','chr9','chr10','chr11','chr12','chr13','chr14','chr15','chr16','chr17','chr18','chr20','chrY','chr19','chr22','chr21','chrM'";

#print "Genelist: $genelist\n";

close GENEFILE;

$lengthinput = length($inputfile);

$outputfile = substr($inputfile, 0, $lengthinput-4);

$outputfile = ">".$outputfile."_not_found.txt";

open OUTPUTFILE, "$outputfile" or die "Could not create output file.\n";

$host = "genome-mysql.cse.ucsc.edu";
$tablename = "refGene";
$user = "genome"; 

$dsn = "dbi:mysql:$database:$host";

$connect = DBI->connect($dsn, $user, "") or die "Couldn't connect";

$query = "SELECT * from $tablename WHERE name2 IN ($genelist) AND chrom IN ($chrmlist);";

#print "Query is: $query\n";

$query_handle = $connect->prepare($query);

$query_handle->execute();

@allgenesfound = ();

while($row = $query_handle->fetchrow_hashref)
{
	$chr = $row->{chrom};
	$justnumchr = substr($chr, 3);
	$chrlength = length($justnumchr);
	if($chrlength == 1 && !($justnumchr eq "X" || $justnumchr eq "Y" || $justnumchr eq "M"))
	{
		$justnumchr = "0".$justnumchr;
	}
	$genestart = $row->{txStart};
	$geneend = $row->{txEnd};
	$genename = $row->{name2};
	push(@allgenesfound, $genename);
	$score = $row->{score};
	$strand = $row->{strand};
	
	$promoterstart = 0;
	$promoterend = 0;
	
	if($strand eq "+")
	{
		$promoterstart = $genestart-2000;
		$promoterend = $genestart;
	}
	elsif($strand eq "-")
	{
		$promoterstart = $geneend;
		$promoterend = $geneend+2000;
	}
	else
	{
		print "No strand information listed for $genename\n";
	}

	#print "$chr\t$justnumchr\t$promoterstart\t$promoterend\t$genename\t$score\t$strand\n";
	print "$chr\t$promoterstart\t$promoterend\t$genename\t$score\t$strand\n";
}

$connect->disconnect();

foreach $gene (@genes)
{
	$found = 0;
	
	foreach $querygene (@allgenesfound)
	{
		if($gene eq $querygene)
		{
			$found = 1;
			last;
		}
	}
	
	if($found == 0)
	{
		print OUTPUTFILE "$gene\n";
	}
}

close OUTPUTFILE;
