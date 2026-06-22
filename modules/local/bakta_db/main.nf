/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    BAKTA_DOWNLOAD_DB process
    Downloads the Bakta light database and caches it permanently via storeDir.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

process BAKTA_DOWNLOAD_DB {
    tag "bakta_db"
    label 'process_single'
    storeDir params.bakta_db_dir ?: "${launchDir}/.db_cache"
    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/bakta:1.12.0--pyhdfd78af_0' :
        'quay.io/biocontainers/bakta:1.12.0--pyhdfd78af_0' }"
    containerOptions workflow.containerEngine == 'docker' ? '--user root' : ''

    output:
    path "db/", emit: db

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    bakta_db download --output tmp_db/ --type full

    # Locate the directory that contains version.json (may be nested inside tmp_db/)
    db_src=\$(dirname \$(find tmp_db/ -name "version.json" -maxdepth 3 | head -1))
    mv "\${db_src}" db

    cat <<-END_VERSIONS > db/versions.yml
    "${task.process}":
        bakta: \$(bakta --version 2>&1 | sed 's/bakta //')
    END_VERSIONS
    """

    stub:
    """
    mkdir -p db
    echo '{"version": "5.1"}' > db/version.json

    cat <<-END_VERSIONS > db/versions.yml
    "${task.process}":
        bakta: 1.12.0
    END_VERSIONS
    """
}
