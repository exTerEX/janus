/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    EGGNOG_MAPPER process
    Runs eggNOG-mapper on Bakta protein FASTA outputs.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

process EGGNOG_MAPPER {
    tag "${meta.id}"
    label 'process_medium'
    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/eggnog-mapper:2.1.12--pyhdfd78af_0' :
        'quay.io/biocontainers/eggnog-mapper:2.1.12--pyhdfd78af_0' }"

    input:
    tuple val(meta), path(faa), path(data_dir)

    output:
    tuple val(meta), path("${meta.prefix}.emapper.annotations"),    emit: annotations
    tuple val(meta), path("${meta.prefix}.emapper.seed_orthologs"), emit: seed_orthologs, optional: true
    tuple val(meta), path("${meta.prefix}.emapper.hits"),           emit: hits, optional: true
    tuple val(meta), path("${meta.prefix}.emapper.orthologs"),      emit: orthologs, optional: true
    path "versions.yml",                                             emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = meta.prefix

    """
    emapper.py \
        -i ${faa} \
        --output ${prefix} \
        --output_dir . \
        --cpu ${task.cpus} \
        --data_dir ${data_dir} \
        ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        eggnog_mapper: \$(emapper.py --version 2>&1 | head -1)
    END_VERSIONS
    """

    stub:
    def prefix = meta.prefix
    """
    touch ${prefix}.emapper.annotations
    touch ${prefix}.emapper.seed_orthologs
    touch ${prefix}.emapper.hits
    touch ${prefix}.emapper.orthologs

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        eggnog_mapper: 2.1.12
    END_VERSIONS
    """
}
