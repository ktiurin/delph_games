#!/bin/bash

for file in genomes/*.fasta; do
  date=$(basename "$file" .fasta)
  sed "s/>/>${date}_/" "$file" >> combined_genomes_with_dates.fasta
done

