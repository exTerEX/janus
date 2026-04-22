# Installation

## Requirements

- [Nextflow](https://www.nextflow.io/) >= 23.04.0 (requires Java 11+)
- A container engine: [Docker](https://www.docker.com/), [Singularity](https://sylabs.io/singularity/),
  [Apptainer](https://apptainer.org/), [Podman](https://podman.io/), or [Conda](https://docs.conda.io/)

## Install Nextflow

```bash
curl -s https://get.nextflow.io | bash
mv nextflow ~/bin/  # or any directory on your $PATH
```

## Container engine

=== "Docker"

```bash
# Install Docker: https://docs.docker.com/get-docker/
docker --version
```

=== "Singularity / Apptainer"

```bash
# Install Apptainer: https://apptainer.org/docs/admin/main/installation.html
apptainer --version
```

=== "Conda"

```bash
# Install Conda: https://docs.conda.io/en/latest/miniconda.html
conda --version
```

## Bakta database

Bakta requires a pre-built database. The pipeline will download it automatically if `--bakta_db` is not provided, but
you can pre-download it for faster runs:

```bash
bakta_db download --output /path/to/bakta_db --type light
```

Or for the full database:

```bash
bakta_db download --output /path/to/bakta_db --type full
```

Then pass `--bakta_db /path/to/bakta_db` when running the pipeline.

## Clone the repository

```bash
git clone https://github.com/exterex/janus.git
cd janus
```

Alternatively, Nextflow can pull the pipeline directly:

```bash
nextflow run exterex/janus --help
```
