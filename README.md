# MiniSR
MiniSR: Short read de-novo Assembly

This short script describes MiniSR pipeline. 
For the example dataset, instructions and results please refere to https://sites.google.com/site/minisrv1/

OR

link to the package with example data: 
https://drive.google.com/open?id=1ZmjlTtnrt4AHQCuVc2KXh-CXVqcfkjgU

This package allows you to test MiniSR on a small dataset.
The package include the following files:
MiniSR.sh that is the script to run MiniSR
sr1.fq  the first file of the paired fastq file
sr2.fq the second file of the paired fastq file
sr.fa interleaved paired read in fasta format
output.log the log file for the example output
output.fa the output of the pipelin
To run the pipeline you need to have minimap2, miniasm, bwa and samtools installed on your machine
you also need the path to the pilon jar file

To re-run the example:

download and extract the directory and enter directory

tar zxvf MiniSR_Example.tar.gz
cd MiniSR_Example

Run MiniSR

bash MiniSR.sh sr1.fq sr2.fq sr.fa 4 PATH_TO_PILON.JAR outputASM.fa 2>&1 | tee output.log
