/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    BAKTA_ANNOTATE workflow
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Annotate bacterial genomes with Bakta.
    Per-sample settings via samplesheet columns: complete, gram, locus_prefix.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { BAKTA             } from '../modules/local/bakta/main'
include { BAKTA_DOWNLOAD_DB } from '../modules/local/bakta_db/main'
include { EGGNOG_DOWNLOAD_DB } from '../modules/local/eggnog_db/main'
include { EGGNOG_MAPPER     } from '../modules/local/eggnog_mapper/main'

workflow BAKTA_ANNOTATE {

    // ── Parse and validate samplesheet ──────────────────────────────────────
    //
    // Required columns : sample, fasta
    // Optional columns : complete, gram, locus_prefix
    //
    Channel
        .fromPath(params.input, checkIfExists: true)
        .splitCsv(header: true, strip: true)
        .map { row ->
            if (!row.fasta) {
                error("ERROR: 'fasta' column is required for sample '${row.sample}'")
            }

            def prefix   = row.locus_prefix ?: row.sample
            def gram     = (row.gram && row.gram.trim()) ? row.gram.trim() : '?'
            def complete = row.complete?.toLowerCase() in ['true', '1', 'yes']

            def meta = [id: row.sample, prefix: prefix, gram: gram, complete: complete]
            def fasta = file(row.fasta, checkIfExists: true)

            return [meta, fasta]
        }
        .set { ch_samples }

    // ── Download / reuse databases ──────────────────────────────────────────
    //   Bakta   → <bakta_db_dir>/db/
    //   eggNOG  → <eggnog_db_dir>/eggnog_data/
    BAKTA_DOWNLOAD_DB()
    ch_db = BAKTA_DOWNLOAD_DB.out.db

    // ── Run Bakta ───────────────────────────────────────────────────────────

    ch_bakta_input = ch_samples.combine(ch_db)
        .map { meta, fasta, db -> [meta, fasta, db] }

    BAKTA(ch_bakta_input)

    if (params.eggnog_run) {
        EGGNOG_DOWNLOAD_DB()
        ch_eggnog_db    = EGGNOG_DOWNLOAD_DB.out.db
        ch_eggnog_input = BAKTA.out.faa.combine(ch_eggnog_db)
        EGGNOG_MAPPER(ch_eggnog_input)
    }
}
