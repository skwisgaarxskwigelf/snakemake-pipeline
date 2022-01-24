GENOME_PATH = "/mnt/tank/scratch/azamyatin/SPONGES/MAGS/MAGseqs"
#IDS = glob_wildcards(GENOME_PATH + "/SAP2.{id}.fasta").id
IDS = ['001', '002', '003']


rule all:
    input:
        "out/summary.xlsx"


rule csv_to_excel:
    input: 
        "out/common/busco_summary.csv",
        "out/common/report.tsv"
    output:
        "out/summary.xlsx"
    script:
        "scripts/csv_to_excel.py"


rule quast_report_common:
    input: 
        "out/quast_results"
    output:
        "out/common/report.tsv"
    shell:
        """
        cp {input}/report.tsv {output}
        """


rule busco_txts_to_csv:
    input:
        expand("out/busco_results/{id}", id=IDS)
    output:
        "out/common/busco_summary.csv"
    params:
        lineage="bacteria",
        id=IDS,
    script:
        "scripts/txt_to_csv.py"


rule run_busco:
    input:
        GENOME_PATH + "/SAP2.{id}.fasta"
    output:
        directory("out/busco_results/{id}")
    log:
        "out/busco_logs/{id}.log"
    params:
        mode="genome",
        lineage="bacteria",
        download_path="out/busco_downloads"
    wrapper:
        "0.84.0/bio/busco"


rule run_quast:
    input:
        expand("{gp}/SAP2.{id}.fasta", gp=GENOME_PATH, id=IDS)
    output: 
        directory("out/quast_results")
    shell:
        """
        bash -c '
            . $HOME/.bashrc
            conda activate $HOME/miniconda3/envs/quastenv
            quast {input} -o {output}
            conda deactivate'
        """

