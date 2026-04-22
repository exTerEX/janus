# Usage

## Samplesheet

The pipeline requires a CSV samplesheet. Only `sample` and `fasta` are required.

| Column         | Required | Description                                                   |
| -------------- | -------- | ------------------------------------------------------------- |
| `sample`       | Yes      | Unique sample identifier                                      |
| `fasta`        | Yes      | Path to genome FASTA file                                     |
| `complete`     | No       | `true` if genome is fully assembled (default: `false`)        |
| `gram`         | No       | Gram stain: `+`, `-`, or `?` (default: `?`)                  |
| `locus_prefix` | No       | Prefix for locus tags and output files (default: sample name) |

Example:

```csv
sample,fasta,complete,gram,locus_prefix
ecoli_k12,genomes/ecoli_k12.fasta,true,-,ECK
staph_aureus,genomes/s_aureus.fasta,false,+,SAU
b_subtilis,genomes/b_subtilis.fasta,,,BSU
```

Empty fields are treated as "not provided" and fall back to defaults.

## Basic usage

```bash
nextflow run exterex/janus \
    --input samplesheet.csv \
    --outdir results \
    -profile docker
```

## Specifying database locations

Both databases are downloaded automatically on first run and cached for subsequent runs.
Use `--bakta_db_dir` and `--eggnog_db_dir` to control where they are stored — useful for
shared HPC storage where the same databases are reused across users and projects.

```bash
nextflow run exterex/janus \
    --input samplesheet.csv \
    --bakta_db_dir /shared/databases/bakta \
    --eggnog_db_dir /shared/databases/eggnog \
    --outdir results \
    -profile docker
```

## Disabling eggNOG-mapper

eggNOG-mapper runs by default. To skip it:

```bash
nextflow run exterex/janus \
    --input samplesheet.csv \
    --outdir results \
    --eggnog_run false \
    -profile docker
```

## Profiles

| Profile       | Description                        |
| ------------- | ---------------------------------- |
| `docker`      | Run with Docker containers         |
| `singularity` | Run with Singularity containers    |
| `apptainer`   | Run with Apptainer containers      |
| `podman`      | Run with Podman containers         |
| `conda`       | Run with Conda environments        |
| `test`        | Minimal test dataset               |

## Resuming a run

```bash
nextflow run exterex/janus \
    --input samplesheet.csv \
    --outdir results \
    -profile docker \
    -resume
```
