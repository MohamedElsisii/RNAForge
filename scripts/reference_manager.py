#!/usr/bin/env python3

import argparse
import sys
import subprocess
import json
import subprocess
import zipfile
from pathlib import Path


def download_reference(accession, zip_path):
    """
    Download an NCBI reference genome using the Datasets CLI.
    """

    try:
        subprocess.run(
            [
                "datasets",
                "download",
                "genome",
                "accession",
                accession,
                "--include",
                "genome,gff3,gtf",
                "--filename",
                str(zip_path)
            ],
            check=True,
            capture_output=True,
            text=True
        )

    except subprocess.CalledProcessError as e:

        details = e.stderr.strip() if e.stderr else ""

        message = f"""
ERROR: Unable to retrieve the reference assembly '{accession}'.

Please verify that:
  • The assembly accession exists.
  • The accession is spelled correctly.
  • You have an internet connection.

"""

        if details:
            message += f"\nNCBI error:\n{details}\n"

        sys.exit(message)


def extract_reference(zip_path, output_dir):
    """Extract the downloaded reference package."""

    with zipfile.ZipFile(zip_path, "r") as zip_ref:
        zip_ref.extractall(output_dir)


def find_reference_files(reference_dir):
    """Locate the important reference files."""

    reference_dir = Path(reference_dir)

    files = {
        "genome": None,
        "gtf": None,
        "gff": None,
    }

    for file in reference_dir.rglob("*"):

        if not file.is_file():
            continue

        name = file.name.lower()

        if name.endswith("_genomic.fna"):
            files["genome"] = file

        elif name.endswith(".gtf"):
            files["gtf"] = file

        elif name.endswith(".gff") or name.endswith(".gff3"):
            files["gff"] = file

    return files

def save_metadata(accession, files, reference_dir):
    """Save reference metadata to metadata.json."""

    if files["gtf"]:
        annotation = files["gtf"].resolve()
        annotation_format = "gtf"
    elif files["gff"]:
        annotation = files["gff"].resolve()
        annotation_format = "gff"
    else:
        annotation = None
        annotation_format = None

    metadata = {
        "assembly": accession,
        "genome": str(files["genome"].resolve()) if files["genome"] else None,
        "gtf": str(files["gtf"].resolve()) if files["gtf"] else None,
        "gff": str(files["gff"].resolve()) if files["gff"] else None,

    # Preferred annotation
        "annotation": str(annotation) if annotation else None,
        "annotation_format": annotation_format,

        "indexes": {
            "hisat2": False,
            "bowtie2": False,
            "bwa": False,
            "star": False
        }
    }

    metadata_file = Path(reference_dir) / "metadata.json"

    with open(metadata_file, "w") as f:
        json.dump(metadata, f, indent=4)

    return metadata_file

def load_metadata(metadata_file):

    with open(metadata_file, "r") as f:
        return json.load(f)
        
def main():

    parser = argparse.ArgumentParser(
        description="Download and prepare NCBI reference genomes."
    )

    parser.add_argument(
        "--field",
        choices=["genome", "gtf", "gff", "metadata", "reference_dir","annotation","annotation_format"],
        help="Print a single metadata field."
    )

    parser.add_argument(
        "--assembly",
        required=True,
        help="NCBI Assembly accession (e.g. GCF_000005845.2)",
    )

    parser.add_argument(
        "--json",
        action="store_true",
        help="Print metadata as JSON."
    )

    parser.add_argument(
        "--force",
        action="store_true",
        help="Force redownload of the reference."
    )

    args = parser.parse_args()

    reference_dir = (
        Path.home()
        / ".rnalyze"
        / "references"
        / args.assembly
    )
    reference_dir.mkdir(parents=True, exist_ok=True)

    zip_path = reference_dir / "reference.zip"
    metadata_path = reference_dir / "metadata.json"

    # ------------------------------------------------------------------
    # Load existing reference or download a new one
    # ------------------------------------------------------------------

    if metadata_path.exists() and not args.force:

        if not (args.json or args.field):
            print("Reference already prepared.")

        metadata = load_metadata(metadata_path)

    else:

        if args.force or not zip_path.exists():

            if not (args.json or args.field):
                print("Downloading reference...")

            download_reference(args.assembly, zip_path)

        dataset_dir = reference_dir / "ncbi_dataset"

        if not dataset_dir.exists() or args.force:

            if not (args.json or args.field):
                print("Extracting reference...")

            extract_reference(zip_path, reference_dir)

        else:

            if not (args.json or args.field):
                print("Reference already extracted.")

        if not (args.json or args.field):
            print("Finding reference files...")

        files = find_reference_files(reference_dir)

        metadata_path = save_metadata(
            args.assembly,
            files,
            reference_dir
        )

        metadata = load_metadata(metadata_path)

    # ------------------------------------------------------------------
    # Output modes
    # ------------------------------------------------------------------

    if args.field:

        if args.field == "metadata":
            print(metadata_path.resolve())
        elif args.field == "reference_dir":
            print(reference_dir.resolve())
        else:
            print(metadata[args.field])

        return

    if args.json:
        print(json.dumps(metadata, indent=4))
        return

    # ------------------------------------------------------------------
    # Human-readable output
    # ------------------------------------------------------------------

    print("\nReference ready!\n")

    print(f"Assembly   : {metadata['assembly']}")
    print(f"Genome     : {metadata['genome']}")
    print(f"GTF        : {metadata['gtf']}")
    print(f"GFF        : {metadata['gff']}")

    print("\nIndexes:")

    for aligner, built in metadata["indexes"].items():
        status = "Built" if built else "Not built"
        print(f"  {aligner:<10} {status}")
        
if __name__ == "__main__":
    main()
