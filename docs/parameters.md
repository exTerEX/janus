# Parameters

## Input/output options

| Parameter  | Default    | Description                                       |
| ---------- | ---------- | ------------------------------------------------- |
| `--input`  | _required_ | Path to CSV samplesheet (sample, fasta required). |
| `--outdir` | `results`  | Output directory for results.                     |

## Database options

Both databases are downloaded automatically on first run and reused on subsequent runs
via Nextflow's `storeDir` mechanism. Point these to shared storage on HPC systems.

| Parameter         | Default                  | Description                                                  |
| ----------------- | ------------------------ | ------------------------------------------------------------ |
| `--bakta_db_dir`  | `${launchDir}/.db_cache` | Directory where the Bakta database is stored or downloaded.  |
| `--eggnog_db_dir` | `${launchDir}/.db_cache` | Directory where the eggNOG database is stored or downloaded. |

## Bakta options

Per-sample settings (`complete`, `gram`, `locus_prefix`) are set via samplesheet columns,
not pipeline parameters.

| Parameter          | Default | Description                                        |
| ------------------ | ------- | -------------------------------------------------- |
| `--bakta_extra_args` | `""`  | Additional CLI arguments passed directly to bakta. |

## eggNOG-mapper options

| Parameter      | Default | Description                                             |
| -------------- | ------- | ------------------------------------------------------- |
| `--eggnog_run` | `true`  | Run eggNOG-mapper on Bakta protein FASTA outputs (faa). |

## Generic options

| Parameter            | Default | Description                                          |
| -------------------- | ------- | ---------------------------------------------------- |
| `--publish_dir_mode` | `copy`  | Method used to save pipeline results to output dir.  |
| `--monochrome_logs`  | `false` | Disable coloured log output.                         |
| `--help`             | `false` | Display help text.                                   |
| `--version`          | `false` | Display version and exit.                            |
