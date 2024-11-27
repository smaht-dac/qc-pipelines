# Download GTEX data from here: https://gtexportal.org/home/downloads/adult-gtex/bulk_tissue_expression

# Prepare training data
# Remove 2nd col
# cut -d$'\t' -f 1,3- GTEx_Analysis_v10_RNASeQCv2.4.2_gene_tpm.processed.gct > GTEx_Analysis_v10_RNASeQCv2.4.2_gene_tpm.processed.gct
# sed -i -e '1,2d' GTEx_Analysis_2017-06-05_v8_RNASeQCv1.1.9_gene_tpm.test.gct
import pandas as pd
import numpy as np
import pickle
from sklearn.preprocessing import StandardScaler
from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, classification_report
from imblearn.over_sampling import SMOTE
from collections import Counter
from sklearn.model_selection import GridSearchCV


GTEX_TISSUES = [
    "Lung",
    "Small Intestine",
    "Pancreas",
    "Spleen",
    "Breast",
    "Stomach",
    "Kidney",
    "Fallopian Tube",
    "Bone Marrow",
    "Blood Vessel",
    "Adipose Tissue",
    "Muscle",
    "Brain",
    "Heart",
    "Uterus",
    "Ovary",
    "Prostate",
    "Bladder",
    "Thyroid",
    "Colon",
    "Adrenal Gland",
    "Blood",
    "Testis",
    "Skin",
    "Pituitary",
    "Liver",
    "Vagina",
    "Salivary Gland",
    "Cervix Uteri",
    "Esophagus",
    "Nerve",
]


# What we will get in portal
# Adrenal Glands
# Aorta
# Blood
# Brain
# Frontal lobe
# Temporal lobe
# Cerebellum
# Hippocampus
# Buccal swab
# Ascending colon
# Descending colon
# Esophagus
# Fibroblasts (grown up from the calf tissue)
# Gonads (i.e. testes or ovaries)
# Heart
# Liver
# Lung
# Muscle
# Skin (abdomen - not sun-exposed)
# Skin (calf - sun-exposed)


CLASSIFIER_VERSION = "20241125"

GTEX_RNASEQ_DATA_FILE = "GTEx_Analysis_v10_RNASeQCv2.4.2_gene_tpm.processed.gct"
METADATA_FILE = "GTEx_Analysis_v10_Annotations_SampleAttributesDS.txt"

# Load RNA-seq TPM data
rna_data = pd.read_csv(GTEX_RNASEQ_DATA_FILE, sep="\t", index_col=0)
rna_data.index = rna_data.index.map(lambda x: x.split(".")[0])

# Load sample metadata
metadata = pd.read_csv(METADATA_FILE, sep="\t")

# Filter metadata to keep relevant columns (e.g., sample ID and tissue type)
metadata = metadata[["SAMPID", "SMTS"]]

# List all GTEX tissues
# column = metadata["SMTS"].tolist()
# print(list(set(column)))
# exit()

# Ensure the sample IDs in the RNA data match the metadata
# The columns in RNA data correspond to samples; ensure they match with 'SAMPID' in metadata
tissue_labels = metadata.set_index("SAMPID").loc[rna_data.columns]["SMTS"]

# Check if the sample order matches
assert all(tissue_labels.index == rna_data.columns), "Sample mismatch!"

print("All RNA data")
print(rna_data)

# Only keep tissues that we have in the portal - currently disabled
filtered_cols = [
    col for col in rna_data.columns if (tissue_labels[col] in GTEX_TISSUES)
]

# Feature selection. Only use genes with high variance, i.e., different expression levels in different samples
rna_data = rna_data[filtered_cols]
rna_data["variance"] = rna_data.iloc[:, 2 : rna_data.shape[1]].var(axis=1)
rna_data = rna_data.loc[rna_data["variance"] > 10.0]  # filter by variance column
rna_data = rna_data.drop(columns=["variance"])

# add average TPM column & filter <- This does not help and we get lower accuracy with that filter
# rna_data['avg_tpm'] = rna_data.iloc[:,2:rna_data.shape[1]].mean(axis=1)
# rna_data = rna_data.nlargest(1000,'avg_tpm')
# rna_data = rna_data.drop(columns=['avg_tpm'])

tissue_labels = tissue_labels[filtered_cols]
print(Counter(tissue_labels.tolist()))

# Check the data
print("Filtered RNA data")
print(rna_data)

# Store the genes that actually go into the model
pickle.dump(rna_data.index, open(f"genes_list_{CLASSIFIER_VERSION}.pkl", "wb"))

# Standardize the data (mean = 0, variance = 1)
scaler = StandardScaler()
rna_data_scaled = scaler.fit_transform(rna_data.T)  # Transpose so samples are rows
pickle.dump(scaler, open(f"scaler_{CLASSIFIER_VERSION}.pkl", "wb"))

# Convert scaled data back to a DataFrame
rna_data_scaled = pd.DataFrame(
    rna_data_scaled, index=rna_data.columns, columns=rna_data.index
)

# Encode tissue types into numerical values
le = LabelEncoder()
tissue_labels_encoded = le.fit_transform(tissue_labels)
decoded_labels = le.inverse_transform(tissue_labels_encoded)
print(tissue_labels)

# Store the LabelEncoder
pickle.dump(le, open(f"labelencoder_{CLASSIFIER_VERSION}.pkl", "wb"))

# Split data into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(
    rna_data_scaled, tissue_labels_encoded, test_size=0.15, random_state=42
)

# Apply SMOTE to balance the training data
smote = SMOTE(random_state=42)
X_train, y_train = smote.fit_resample(X_train, y_train)

############################################
# Search for optimal hyperparameters
# Initialize a random forest classifier

# rf = RandomForestClassifier(random_state=42)
#
# Define the parameter grid
# param_grid = {
#    'n_estimators': [100, 125],
#    'max_depth': [None, 10, 20],
#    'min_samples_split': [2, 5],
#    'min_samples_leaf': [1, 2],
#    #'max_features': ['sqrt', 'log2']
# }

# Set up the GridSearchCV
# grid_search = GridSearchCV(estimator=rf, param_grid=param_grid, cv=5, n_jobs=2, verbose=2)

# Fit on the data
# grid_search.fit(X_train, y_train)

# Best parameters and score
# print("Best Parameters:", grid_search.best_params_)
# print("Best Score:", grid_search.best_score_)
# exit()
# Best Parameters: {'max_depth': None, 'min_samples_leaf': 1, 'min_samples_split': 2, 'n_estimators': 125}
# Best Score: 0.99954089646007
#############################################

# Initialize a random forest classifier
# clf = RandomForestClassifier(n_estimators=125, random_state=42)
clf = RandomForestClassifier(
    n_estimators=125,
    max_depth=None,
    min_samples_leaf=1,
    min_samples_split=2,
    random_state=42,
)

# Train the model on the training data
clf.fit(X_train, y_train)

# Save the model
pickle.dump(clf, open(f"random_forest_model_{CLASSIFIER_VERSION}.pkl", "wb"))

# Make predictions on the test set
y_pred = clf.predict(X_test)
# Use predict_proba to get probability estimates for the test data
y_pred_prob = clf.predict_proba(X_test)

# Calculate accuracy
accuracy = accuracy_score(y_test, y_pred)
print(f"Accuracy: {accuracy * 100:.2f}%")

# Detailed classification report
print(classification_report(y_test, y_pred))

label_mapping = {index: label for index, label in enumerate(le.classes_)}

with open(f"test_results_{CLASSIFIER_VERSION}.txt", "w") as file:

    file.write(f"Actual\tPrediction\tProbability 1\t Probability 2\n")
    for index, pred in enumerate(y_pred):
        probabilities = y_pred_prob[index]
        p_mapping = {}
        for p_ind, p in enumerate(probabilities):
            p_mapping[label_mapping[p_ind]] = p
        sorted_p_mapping = dict(
            sorted(p_mapping.items(), key=lambda item: item[1], reverse=True)
        )
        sorted_p_mapping = dict(list(sorted_p_mapping.items())[:2])
        probs_str = ""
        for t in sorted_p_mapping:
            probs_str += f"\t{t}: {sorted_p_mapping[t]}"

        file.write(
            f"{label_mapping[y_test[index]]}\t{label_mapping[pred]}{probs_str}\n"
        )
