#!/bin/bash

# Set the number of iterations
num_iterations=20

for ((i = 1; i <= num_iterations; i++)); do
    # Create padded strings for the crie number and folder names
    crie_num=$(printf "crie_%05d" $((1086 + i - 1)))
    folder_num=$(printf "%d" $i)

    # Create directories
    mkdir -p ./$folder_num/$folder_num/

    # Run bowtie2
    bowtie2 -p 10 -1 ./reads/2022-01-26_fastq_named/${crie_num}_L001_R1_001.fastq.gz -2 ./reads/2022-01-26_fastq_named/${crie_num}_L001_R2_001.fastq.gz -x ./ref/index/Gemone.bt2index --sensitive --no-unal -S ./$folder_num/sample$folder_num.sam

    # Process the alignment with samtools
    samtools view -bS -F 0x4 ./$folder_num/sample$folder_num.sam -o ./$folder_num/sample$folder_num.bam
    samtools sort ./$folder_num/sample$folder_num.bam -o ./$folder_num/$folder_num/sample.sorted$folder_num.bam
    samtools index ./$folder_num/$folder_num/sample.sorted$folder_num.bam
done
