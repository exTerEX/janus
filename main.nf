#!/usr/bin/env nextflow

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    exterex/janus
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Bacterial genome annotation with Bakta and legacy locus tag transfer.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

nextflow.enable.dsl = 2

include { BAKTA_ANNOTATE } from './workflows/bakta_annotate'

workflow {
    BAKTA_ANNOTATE()
}

workflow.onComplete {
    log.info(workflow.success ? "\nPipeline completed successfully.\n" : "\nPipeline failed.\n")
}
