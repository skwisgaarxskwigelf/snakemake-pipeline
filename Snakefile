GENOME_PATH = "/mnt/tank/scratch/azamyatin/SPONGES/MAGS/MAGseqs"
#IDS = glob_wildcards(GENOME_PATH + "/SAP2.{id}.fasta").id
IDS = ['001', '002', '003']


rule all:
    input:
        "summary.xlsx"


rule csv_to_excel:
    input: 
        "common/busco_summary.csv",
        "common/report.tsv"
    output:
        "summary.xlsx"
    script:
        "scripts/csv_to_excel.py"


rule quast_report_common:
    input: 
        "quast_results"
    output:
        "common/report.tsv"
    shell:
        """
        cp {input}/latest/report.tsv {output}
        """


rule busco_txts_to_csv:
    input:
        expand("busco_results/{id}", id=IDS)
    output:
        "common/busco_summary.csv"
    params:
        lineage="bacteria",
        id=IDS,
    script:
        "scripts/txt_to_csv.py"


rule run_busco:
    input:
        GENOME_PATH + "/SAP2.{id}.fasta"
    output:
        directory("busco_results/{id}")
    log:
        "busco_logs/{id}.log"
    params:
        mode="genome",
        lineage="bacteria",
    wrapper:
        "0.84.0/bio/busco"


rule run_quast:
    input:
        expand("{gp}/SAP2.{id}.fasta", gp=GENOME_PATH, id=IDS)
    output: 
        directory("quast_results")
    shell:
        """
        bash -c '
            . $HOME/.bashrc
            conda activate $HOME/miniconda3/envs/quastenv
            quast {input}
            conda deactivate'
        """

