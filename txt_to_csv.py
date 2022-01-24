import re
import pandas as pd
import os


def get_rates(s: str) -> list:
    s.replace('[', '')
    s.replace(']', '')

    s = s.split('%')
    rates = []
    for i in s:
        i = i.split(':')
        rates.append(i[1])

    return rates


def write_to_csv(rates: list):
    head = ['C', 'S', 'D', 'F', 'M', 'n']
    df=pd.DataFrame(rates,columns=head)
    df.to_csv(snakemake.output[0], index=None)


def run():
    rates_matrix = []
    search_pattern = 'C.*S.*D.*F.*M.*n'

    for inp in snakemake.input:
        for f in os.listdir(inp):
            if re.match('short_summary.specific.'+ snakemake.params.lineage + '.*.txt', f):
                full_path = os.path.join(inp, f)
                # go thru .txt file lines
                for line in open(full_path, 'r'):
                    line_s = line.strip()
                    # regex needed line
                    if bool(re.search(search_pattern, line_s)):
                        # get percentages from needed line
                        rates = get_rates(line_s)
                        rates_matrix.append(rates)
                        break
 
    if len(rates_matrix):
        write_to_csv(rates_matrix)


if __name__ == '__main__':
    run()

