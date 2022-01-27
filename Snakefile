configfile: "config.yaml"

GENOME_PATH = config["path"] 
quast_path = config["quast_path"]
busco_path = config["busco_path"]
IDS = glob_wildcards(GENOME_PATH + "/{id}.fasta").id


rule all:
    input:
        "out/summary.xlsx"


rule csv_to_excel:
    input: 
        "out/common/busco_summary.csv",
        "out/common/report.tsv"
    output:
        "out/summary.xlsx"
    params:
        busco_out="out/common/busco_summary.csv",
        quast_out="out/common/report.tsv"
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
        GENOME_PATH + "/{id}.fasta"
    output:
        directory("out/busco_results/{id}")
    params:
        mode="genome",
        lineage="bacteria",
        download_path="out/busco_downloads",
        path=busco_path,
        out_path="out/busco_results/",
        out_file="{id}"
    shell:
        """
        bash -c '
            . $HOME/.bashrc
            conda activate {params.path}
            busco -i {input} -l {params.lineage} -m genome --out_path {params.out_path} -o {params.out_file}
            conda deactivate'
        """


rule run_quast:
    input:
        expand("{gp}/{id}.fasta", gp=GENOME_PATH, id=IDS)
    output: 
        directory("out/quast_results")
    params:
        path=quast_path
    shell:
        """
        bash -c '
            . $HOME/.bashrc
            conda activate {params.path}
            quast {input} -o {output}
            conda deactivate'
        """

