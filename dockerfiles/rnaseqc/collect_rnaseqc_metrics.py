

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
    result = {}
    metrics_tsv = f"{metrics_folder}{sample}.metrics.tsv"
    with open(metrics_tsv) as f:
        for line in f:
            l = line.split('\t')
            metric = l[0]
            metric = metric.replace(" ", "_").lower()
            value = l[1]
            if metric == "sample": # first line
                continue
            result[metric] = value

    #####
    # WORK IN PROGRESS. Extact more metrics from other result file.
    ####
    

    # Save it to file
    with open(out, "w") as outfile:
        result_enc = json.dumps(result, indent=4)
        outfile.write(result_enc)


if __name__ == "__main__":
    main()
