/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    EGGNOG_DOWNLOAD_DB process
    Downloads the eggNOG-mapper database and caches it permanently via storeDir.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

process EGGNOG_DOWNLOAD_DB {
    tag "eggnog_db"
    label 'process_single'
    storeDir params.eggnog_db_dir ?: "${launchDir}/.db_cache"
    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/eggnog-mapper:2.1.12--pyhdfd78af_0' :
        'quay.io/biocontainers/eggnog-mapper:2.1.12--pyhdfd78af_0' }"
    containerOptions workflow.containerEngine == 'docker' ? '--user root' : ''

    output:
    path "eggnog_data/", emit: db

    when:
    task.ext.when == null || task.ext.when

    script:
    def base_url = 'http://eggnog5.embl.de/download/emapperdb-5.0.2'
    """
    mkdir -p eggnog_data

    wget --tries=0 --retry-connrefused --waitretry=60 --continue -q -O eggnog_data/eggnog.db.gz ${base_url}/eggnog.db.gz
    gunzip eggnog_data/eggnog.db.gz

    wget --tries=0 --retry-connrefused --waitretry=60 --continue -q -O eggnog_data/eggnog.taxa.tar.gz ${base_url}/eggnog.taxa.tar.gz
    tar -zxf eggnog_data/eggnog.taxa.tar.gz -C eggnog_data/
    rm eggnog_data/eggnog.taxa.tar.gz

    curl --retry 50 --retry-delay 30 --retry-connrefused --retry-all-errors \
        --continue-at - -L -o eggnog_data/eggnog_proteins.dmnd.gz \
        ${base_url}/eggnog_proteins.dmnd.gz
    gunzip eggnog_data/eggnog_proteins.dmnd.gz

    cat <<-END_VERSIONS > eggnog_data/versions.yml
    "${task.process}":
        eggnog_mapper: \$(emapper.py --version 2>&1 | head -1)
    END_VERSIONS
    """

    stub:
    """
    mkdir -p eggnog_data
    touch eggnog_data/.download_complete

    cat <<-END_VERSIONS > eggnog_data/versions.yml
    "${task.process}":
        eggnog_mapper: 2.1.12
    END_VERSIONS
    """
}
