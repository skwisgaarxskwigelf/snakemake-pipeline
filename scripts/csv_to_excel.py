from pandas.io.excel import ExcelWriter
import pandas


def run():
    with ExcelWriter(snakemake.output[0]) as ew:
        for inp in snakemake.input:
            pandas.read_csv(inp).to_excel(ew, sheet_name=inp.split('/')[1])


if __name__ == '__main__':
    run()

