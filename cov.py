import sys
import subprocess
from Bio import SeqIO
from matplotlib import pyplot as plt
import pandas as pd

def plot_coverage(bam_file, gff_file, output_file):
    # Read gene annotations from GFF file
    annotations = pd.read_csv(gff_file, sep='\t', comment='#', header=None, names=['seqid', 'source', 'type', 'start', 'end', 'score', 'strand', 'phase', 'attributes'])

    # Get the depth of coverage at each position
    depth_data = subprocess.run(['samtools', 'depth', bam_file], capture_output=True, text=True).stdout.split('\n')[:-1]
    depth = [int(x.split('\t')[2]) for x in depth_data]

    # Create a figure and set the size
    fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(20, 10), sharex=True, gridspec_kw={'height_ratios': [3, 1]})

    # Plot coverage depth as bar plot
    ax1.bar(range(len(depth)), depth, color='black', width=1)
    ax1.set_title('Sequencing Depth')
    ax1.set_ylabel('Depth')

    # Plot gene annotations
    for _, row in annotations.iterrows():
        if row['type'] == 'gene':
            ax2.barh(0, row['end'] - row['start'], left=row['start'], height=0.01)
            ax2.text(row['start'], 0.5, row['attributes'].split(';')[0].split('=')[1], fontsize=8, va='center')

    ax2.set_title('Gene Annotations')
    ax2.set_xlabel('Genomic Position')
    ax2.set_yticks([])

    # Save the plot to a file
    plt.savefig(output_file)
    plt.close()

if __name__ == "__main__":
    bam_file = sys.argv[1]
    gff_file = sys.argv[2]
    output_file = sys.argv[3]

    plot_coverage(bam_file, gff_file, output_file)


