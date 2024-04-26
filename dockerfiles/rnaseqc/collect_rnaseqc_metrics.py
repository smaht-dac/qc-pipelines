

import click
import json


@click.command()
@click.help_option("--help", "-h")
@click.option("-m", "--metrics-folder", required=True, type=str, help="RNASeQC output folder")
@click.option("-s", "--sample", required=True, type=str, help="Sample name")
@click.option(
    "-o",
    "--out",
    required=True,
    type=str,
    help="Output file that contains the JSON encoded results",
)
def main(metrics_folder, sample, out):
    """This script gathers results from RNASeQC and produces a QC JSON

    Example usage:
    python collect_rnaseqc_metrics.py -m PATH/rnaseqc_output_dir -o metrics.json

    """
    metrics = {}
    metrics_tsv = f"{metrics_folder}/{sample}.metrics.tsv"
    with open(metrics_tsv) as f:
        next(f)  # Skip header
        for line in f:
            l = line.strip().split('\t')
            metric = l[0]
            value = l[1]
            metrics[metric] = value

    # Calculate more metrics based on the RnaSeqQC results
    er = "Exonic Reads"
    ir = "Intronic Reads"
    if er in metrics and ir in metrics:
        intronic_reads = int(metrics[ir])
        exonic_reads = int(metrics[er])
        if (intronic_reads > 0):
            metrics["Exonic/Intron ratio"] = exonic_reads / intronic_reads

    gene_reads_file = f"{metrics_folder}/{sample}.gene_reads.gct"
    (genes_w_mt_0_reads, genes_w_mt_2_reads,
     genes_w_mt_10_reads) = process_reads_gct(gene_reads_file)
    metrics["Genes with >0 reads"] = genes_w_mt_0_reads
    metrics["Genes with >=2 reads"] = genes_w_mt_2_reads
    metrics["Genes with >=10 reads"] = genes_w_mt_10_reads

    exon_reads_file = f"{metrics_folder}/{sample}.exon_reads.gct"
    (exon_w_mt_0_reads, exon_w_mt_2_reads,
     exon_w_mt_10_reads) = process_reads_gct(exon_reads_file)
    metrics["Exons with >0 reads"] = exon_w_mt_0_reads
    metrics["Exons with >=2 reads"] = exon_w_mt_2_reads
    metrics["Exons with >=10 reads"] = exon_w_mt_10_reads

    # Save it to file
    with open(out, "w") as outfile:
        result_enc = json.dumps(metrics, indent=4)
        outfile.write(result_enc)


def process_reads_gct(reads_file):

    lines_w_mt_0_reads = 0
    lines_w_mt_2_reads = 0
    lines_w_mt_10_reads = 0
    with open(reads_file) as f:
        next(f)  # Header: version
        next(f)  # Header: counts
        next(f)  # Header: "Name Descrpition Counts"
        for line in f:
            l = line.strip().split('\t')
            count = int(float(l[2]))
            if count > 0:
                lines_w_mt_0_reads += 1
            if count >= 2:
                lines_w_mt_2_reads += 1
            if count >= 10:
                lines_w_mt_10_reads += 1

    return (lines_w_mt_0_reads, lines_w_mt_2_reads, lines_w_mt_10_reads)


if __name__ == "__main__":
    main()
