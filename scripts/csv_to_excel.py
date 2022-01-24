from pandas.io.excel import ExcelWriter
import pandas
from os import path


def run():
    with ExcelWriter(snakemake.output[0]) as ew:
        pandas.read_csv(snakemake.params.busco_out).to_excel(ew, sheet_name=path.basename(snakemake.params.busco_out), index=False)
        pandas.read_csv(snakemake.params.quast_out, sep="\t").to_excel(ew, sheet_name=path.basename(snakemake.params.quast_out), index=False)


if __name__ == '__main__':
    run()

