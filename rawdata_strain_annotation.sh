#!/bin/bash

num_iterations=20
for ((i = 1; i <= num_iterations; i++)); do
	# Create padded strings for the crie number and folder names
	crie_num=$(printf "crie_%05d" $((1086 + i - 1)))
	folder_num=$(printf "%d" $i)
	bcftools mpileup -Ou -f /home/igorrun/Desktop/bio/K/ref/NC_045512.2.fasta ./$folder_num/$folder_num/sample.sorted$folder_num.bam | bcftools call --ploidy 1 -mv -Ov -o ./$folder_num/variants$folder_num.vcf
	bgzip -c ./$folder_num/variants$folder_num.vcf > ./$folder_num/variants$folder_num.vcf.gz
	bcftools index ./$folder_num/variants$folder_num.vcf.gz
	bcftools consensus -f /home/igorrun/Desktop/bio/K/ref/NC_045512.2.fasta ./$folder_num/variants$folder_num.vcf.gz > ./$folder_num/assembly_${crie_num}.fasta
done

