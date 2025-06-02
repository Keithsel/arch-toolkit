#!/bin/bash

set -e

SOURCE_DIR="path/to/source"  # Replace with your actual source directory
OUTPUT_DIR="path/to/output"  # Replace with your actual output directory
OUTPUT_FORMAT="pdf" # or whatever format you need (e.g., pdf, odt, docx)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$SOURCE_DIR" == "path/to/source" ]]; then
    echo "Error: Please set your source directory in the script."
    echo "Edit the SOURCE_DIR variable in $SCRIPT_DIR/bulk_convert.sh"
    exit 1
fi

if [[ "$OUTPUT_DIR" == "path/to/output" ]]; then
    echo "Error: Please set your output directory in the script."
    echo "Edit the OUTPUT_DIR variable in $SCRIPT_DIR/bulk_convert.sh"
    exit 1
fi

if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "Error: Source directory does not exist: $SOURCE_DIR"
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "Converting documents from $SOURCE_DIR to $OUTPUT_DIR"

for file in "$SOURCE_DIR"/*.{pptx,docx,xlsx,odp,odt,ods}; do
    if [[ -f "$file" ]]; then
        echo "Converting: $(basename "$file")"
        libreoffice --headless --convert-to "$OUTPUT_FORMAT" "$file" --outdir "$OUTPUT_DIR"
    fi
done

echo "Conversion completed"