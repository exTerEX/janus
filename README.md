# janus

**janus** is a [Nextflow](https://www.nextflow.io/) pipeline for bacterial genome annotation using
[Bakta](https://github.com/oschwengers/bakta) with optional functional annotation via
[eggNOG-mapper](https://github.com/eggnogdb/eggnog-mapper).

## Features

- Batch annotation of bacterial genomes via a CSV samplesheet
- Per-sample configuration of genome completeness, Gram stain, and locus tag prefix
- Automatic Bakta database download when no local database is provided
- Optional eggNOG-mapper functional annotation from Bakta protein FASTA outputs
- Automatic eggNOG database download when no local database is provided

## Requirements

- [Nextflow](https://www.nextflow.io/) >= 23.04.0
- [Docker](https://www.docker.com/), [Singularity](https://sylabs.io/singularity/),
  [Apptainer](https://apptainer.org/), [Podman](https://podman.io/), or
  [Conda](https://docs.conda.io/)

## Quick start

```bash
nextflow run exterex/janus \
    --input samplesheet.csv \
    --outdir results \
    -profile docker
```

## Input

A CSV samplesheet with columns:

| Column         | Required | Description                                                   |
| -------------- | -------- | ------------------------------------------------------------- |
| `sample`       | Yes      | Unique sample identifier                                      |
| `fasta`        | Yes      | Path to genome FASTA file                                     |
| `complete`     | No       | `true` if genome is fully assembled (default: `false`)        |
| `gram`         | No       | Gram stain: `+`, `-`, or `?` (default: `?`)                   |
| `locus_prefix` | No       | Prefix for locus tags and output files (default: sample name) |

Example:

```csv
sample,fasta,complete,gram,locus_prefix
ecoli_k12,genomes/ecoli.fasta,true,-,ECK
staph_aureus,genomes/s_aureus.fasta,false,+,SAU
```

## Key parameters

| Parameter         | Default                       | Description                                         |
| ----------------- | ----------------------------- | --------------------------------------------------- |
| `--input`         | _required_                    | Path to samplesheet CSV                             |
| `--outdir`        | `results`                     | Output directory                                    |
| `--bakta_db_dir`  | `${launchDir}/.db_cache`      | Directory for Bakta database (downloaded if absent) |
| `--eggnog_run`    | `true`                        | Run eggNOG-mapper on Bakta protein FASTA files      |
| `--eggnog_db_dir` | `${launchDir}/.db_cache`      | Directory for eggNOG database (downloaded if absent)|

## Output

```text
results/
├── bakta/
│   └── <sample>/          # Full Bakta output per sample
│       ├── <prefix>.gff3
│       ├── <prefix>.gbff
│       ├── <prefix>.fna
│       ├── <prefix>.faa
│       ├── <prefix>.ffn
│       ├── <prefix>.tsv
│       ├── <prefix>.json
│       └── <prefix>.txt
├── eggnog/
│   └── <sample>/          # eggNOG-mapper output per sample
│       └── <prefix>.emapper.*
└── pipeline_info/         # Execution reports
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

## Documentation

Full documentation is available at [https://exterex.github.io/janus](https://exterex.github.io/janus).

## Citations

If you use janus in your research, please cite the tools it wraps. See [CITATIONS.md](CITATIONS.md).

## License

[MIT](LICENSE)
