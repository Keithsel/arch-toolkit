# Usage

## Prerequisites

- `libreoffice`: Document conversion software.

Install dependencies:

```bash
sudo pacman -S libreoffice-fresh
```

## Setup

Make the script executable:

```bash
chmod +x bulk-convert-documents/bulk_convert.sh
```

## Configuration

Edit the following variables in `bulk_convert.sh`:

```bash
SOURCE_DIR="path/to/source"     # Source directory with documents to convert
OUTPUT_DIR="path/to/output"     # Output directory for converted files
OUTPUT_FORMAT="pdf"             # Output format (pdf, odt, docx, etc.)
```

## Running the Script

```bash
cd bulk-convert-documents
./bulk_convert.sh
```

## What it does

Converts all supported document files in the source directory using LibreOffice's headless mode. Supports common formats like docx, pptx, xlsx, odt, odp, and ods.

## Output

Converted documents are saved to your output directory. Default output format is PDF but can be changed by modifying the OUTPUT_FORMAT variable.

## Notes

LibreOffice must be installed and accessible from command line. Original documents are not modified. The script processes all supported files in the source directory.
