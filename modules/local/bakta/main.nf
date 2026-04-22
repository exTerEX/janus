/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    BAKTA process
    Runs Bakta on a single genome FASTA file with comprehensive annotation.
    Per-sample settings (complete, gram, locus_prefix) are passed via meta.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

process BAKTA {
    tag "${meta.id}"
    label 'process_medium'
    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/bakta:1.12.0--pyhdfd78af_0' :
        'quay.io/biocontainers/bakta:1.12.0--pyhdfd78af_0' }"
    containerOptions workflow.containerEngine == 'docker' ? '--user root' : ''

    input:
    tuple val(meta), path(fasta), path(databases)

    output:
    tuple val(meta), path("${meta.prefix}.gff3"),  emit: gff3
    tuple val(meta), path("${meta.prefix}.gbff"),  emit: gbff
    tuple val(meta), path("${meta.prefix}.fna"),   emit: fna
    tuple val(meta), path("${meta.prefix}.ffn"),   emit: ffn,      optional: true
    tuple val(meta), path("${meta.prefix}.faa"),   emit: faa,      optional: true
    tuple val(meta), path("${meta.prefix}.tsv"),   emit: tsv
    tuple val(meta), path("${meta.prefix}.json"),  emit: json
    tuple val(meta), path("${meta.prefix}.txt"),   emit: txt
    tuple val(meta), path("${meta.prefix}.png"),   emit: plot_png, optional: true
    tuple val(meta), path("${meta.prefix}.svg"),   emit: plot_svg, optional: true
    path "versions.yml",                           emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args         = task.ext.args ?: ''
    def prefix       = meta.prefix
    def complete_arg = meta.complete ? '--complete' : '--partial'
    def gram_arg     = "--gram ${meta.gram}"

    """
    bakta \\
        --db ${databases} \\
        --prefix ${prefix} \\
        --output . \\
        --force \\
        --threads ${task.cpus} \\
        --locus ${prefix} \\
        --locus-tag ${prefix} \\
        ${complete_arg} \\
        ${gram_arg} \\
        ${args} \\
        ${fasta}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bakta: \$(bakta --version 2>&1 | sed 's/bakta //')
    END_VERSIONS
    """

    stub:
    def prefix = meta.prefix
    """
    touch ${prefix}.gff3
    touch ${prefix}.gbff
    touch ${prefix}.fna
    touch ${prefix}.ffn
    touch ${prefix}.faa
    touch ${prefix}.tsv
    echo '{}' > ${prefix}.json
    touch ${prefix}.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bakta: 1.12.0
    END_VERSIONS
    """
}
