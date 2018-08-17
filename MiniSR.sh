#!/bin/bash

set -v
set -x

echo "=============================================="
echo "Make sure that minimap2, miniasm, bwa & samtools are installed on your machine "

if [ "$#" -ne 6 ]; then
    echo "Argument 1: Path to the first fastq file of pair end read"
    echo "Argument 2: Path to the second fastq file of pair end read"
    echo "Argument 3: Path to the interleaved fasta file of pair end read"
    echo "Argument 4: Number of threads"
    echo "Argument 5: path to the pilon jar file"
    echo "Argument 6: Output file"
	exit
fi


PE1=$1
PE2=$2
PE=$3
THR=$4
pilon="java -Xmx60g -jar $5"
OUT=$6

function Pilon ()
{
$PROF bwa index $1
$PROF bwa mem -t $THR $1 $PE1 $PE2 | samtools view -Sbu - > $1.bam 
$PROF samtools sort -@$THR -O BAM -o $1.sorted.bam $1.bam 
$PROF samtools index $1.sorted.bam
$PROF $pilon --threads $THR --genome $1 --frags $1.sorted.bam --output $2.pilon.$3  > $1.pilon.out
rm -rf $1.*
}

function MiniSR ()
{
$PROF minimap2 -t $THR -K 10M -f 0.001 -k 28 -w 05 -N 50 -n 1 -X $PE $PE | pigz -p 4 -1 > mm2.paf.gz
$PROF miniasm -m 28 -i 0.5 -s 28 -c 1 -e 2 -f $PE mm2.paf.gz | awk '{if($1=="S") print(">"$2"\n"$3)}' > masm.fa
Pilon masm.fa masm 1
rm -rf mm2.paf.gz masm.fa
mv masm.pilon.1.fasta $OUT
}

MiniSR

echo ">>> output assembly is stored in $6"
echo "=============================================="

exit

