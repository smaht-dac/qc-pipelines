#!/usr/bin/env python3

import click, sys, subprocess, csv, pickle
import pandas as pd

RANDOM_FOREST_MODEL = "random_forest_model.pkl"
GENES_LIST = "genes_list.pkl"
LABEL_ENCODER = "labelencoder.pkl"
SCALER = "scaler.pkl"


def load_rnaseqqc_result_from_file(path_to_rnaseqqc_output):
    result = {}
    with open(path_to_rnaseqqc_output, newline="") as file:
        reader = csv.reader(file, delimiter="\t")
        next(reader)
        next(reader)
        next(reader)
        for row in reader:
            gene_id = row[0]
            stable_gene_id = gene_id.split(".")[0]
            result[stable_gene_id] = float(row[2])
    return result


def get_model_input(rnaseqqc_result, genes_list, scaler):

    expression = []
    for g in genes_list:
        if g in rnaseqqc_result:
            expression.append(rnaseqqc_result[g])
        else:
            expression.append(0)

    # Create a DataFrame with 1 row and the given column names
    exp_df = pd.DataFrame([expression], columns=genes_list)
    exp_df.index = ["Sample"]

    exp_scaled = scaler.transform(exp_df)
    #expression_scaled = expression
    exp_scaled_df = pd.DataFrame(exp_scaled, columns=genes_list)
    exp_scaled_df.index = ["Sample"]
    return exp_scaled_df

def predict_input(expression_scaled, ml_model, label_encoder):
    label_mapping = {index: label for index, label in enumerate(label_encoder.classes_)}
    predicted_proba = ml_model.predict_proba(expression_scaled)[0]

    p_mapping = {}
    for p_ind, p in enumerate(predicted_proba):
        p_mapping[label_mapping[p_ind]] = p
    sorted_p_mapping = dict(sorted(p_mapping.items(), key=lambda item: item[1], reverse=True))
    sorted_p_mapping = dict(list(sorted_p_mapping.items()))

    probs_arr = []
    for t in sorted_p_mapping:
        probs_arr.append({
            "tissue": t,
            "probability": sorted_p_mapping[t]
        })
    
    return probs_arr


@click.command()
@click.option(
    "-c",
    "--classifier",
    required=True,
    help="Path to classifier source files from portal",
)
@click.option(
    "-r",
    "--rnaseqc-output",
    required=True,
    help="Result of RNA-SeQC",
)
def main(classifier, rnaseqc_output):
    """Predict the tissue from RNA-SeQC output using a trained model

    Args:
        classifier (file): Classifier source files
        rnaseqc_output (file): Result of RNA-SeQC
    """

    # Extract classifier. Creates
    # genes_list.pkl, labelencoder.pkl, scaler.pkl,  random_forest_model.pkl
    # in the folder of this script
    try:
        subprocess.run(["tar", "-xzf", classifier], check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error occurred: {e}")

    with open(RANDOM_FOREST_MODEL, "rb") as f:
        ml_model = pickle.load(f)

    with open(GENES_LIST, "rb") as f:
        genes_list = pickle.load(f)

    with open(LABEL_ENCODER, "rb") as f:
        label_encoder = pickle.load(f)

    with open(SCALER, "rb") as f:
        scaler = pickle.load(f)

    rnaseqqc_result = load_rnaseqqc_result_from_file(rnaseqc_output)

    model_input = get_model_input(
        rnaseqqc_result=rnaseqqc_result,
        genes_list=genes_list,
        scaler=scaler,
    )

    result = predict_input(model_input, ml_model, label_encoder)

    with open("output.txt", "w") as file:
        for i, r in enumerate(result):
            file.write(f"Predicted tissue {i+1}\t{r['tissue']}\n")
            file.write(f"Probability predicted tissue {i+1}\t{r['probability']}\n")



if __name__ == "__main__":
    sys.exit(main())
