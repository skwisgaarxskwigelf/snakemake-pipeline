import pandas as pd 

if __name__ == 'main':
    tsv_file=snakemake.input[0]
    csv_table=pd.read_table(tsv_file,sep='\t')
    csv_table.to_csv(snakemake.output[0], index=False)

