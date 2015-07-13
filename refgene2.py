#!/usr/bin/env python
#
# Given a list of gene names in a file, get genomic coordinates of the promoters
# A promoter is defined as a region 2000bp upstream, 500bp downstream of transcription start site
# Strand specificity matters. HG19 is currently hard-coded
#
# Example: python refgene2.py txt/all.refGene.txt | bedtools sort -i - | mergeBed -s -c 4 -o distinct -i - > all.refGene2.bed
# Another output is "notfound" file, containing genes that weren't found in the database
#
# https://stackoverflow.com/questions/27309187/django-exception-value-2013-2013-lost-connection-to-mysql-server-during-que
# trick to avoid connection timeout
# pip install -U --allow-external mysql-connector-python mysql-connector-python==1.2.3
#
import csv, sys, mysql.connector, argparse, os, pdb, math

db = mysql.connector.connect(user="genome", 
    password="", database="hg19", host="genome-mysql.cse.ucsc.edu", connection_timeout=600)
c = db.cursor()

if __name__ == "__main__":
    goodchrom = "'chr1','chr2','chr3','chr4','chr5','chr6','chr7','chrX','chr8','chr9','chr10','chr11','chr12','chr13','chr14','chr15','chr16','chr17','chr18','chr20','chrY','chr19','chr22','chr21','chrM'";

    parser = argparse.ArgumentParser()
    parser.add_argument("snp_file", nargs=1)
    args = parser.parse_args()

    genelist = [row.strip() for row in open(args.snp_file[0])] # Full gene list

    h2 = open(args.snp_file[0][:-4]+".notfound.txt", "w") # File to save genes that can't be found
    
    # Queueing gene list 100 genes at times, to work aroung the error: mysql.connector.errors.InterfaceError: 2013: Lost connection to MySQL server during query
    a = 0
    n = 100
    for i in range(int(math.ceil(len(genelist)/100.0))): # Up round the number of chunks
        if a*n > len(genelist): # If the last chunk
            n = len(genelist) # Set n to maximum length
        else:
            n = (a+1)*100
        # Otherwise, get 100 genes chunk
        glist = genelist[(a*100):(n)]

        q = """SELECT chrom, txStart, txEnd, name2, strand from refGene WHERE name2 IN (%s) AND chrom IN (%s);""" % ("'"+"','".join(glist)+"'", goodchrom)
        c.execute(q)
        d=c.fetchall()
        genesout = []
        for row in d:
            genesout.append(row[3]) # Collect genes that were obtained from the database
            if row[4] == "+":
                print "\t".join([row[0], str(row[1]-2000), str(row[1]+500), row[3], "0", row[4]])
            else:
                print "\t".join([row[0], str(row[2]-500), str(row[2]+2000), row[3], "0", row[4]])
        genesdiff = list(set(glist) - set(genesout)) # Get the difference between input and output gene lists
        h2.write("\n".join(genesdiff)) # Save genes that were not found in the current chunk

        a = a + 1 # Increase count of chunks
        
    h2.close()
db.close()
