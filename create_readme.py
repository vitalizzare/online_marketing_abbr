#!/usr/bin/env python

import pandas as pd


abbr_file = 'abbr.csv'
readme_file = 'README.md'
data = pd.read_csv(abbr_file, index_col=0, header=None, names=['ABBR'], squeeze=True)

data = data.sort_index()
with open(readme_file, 'w') as f:
    f.write('ABBR|DESCRIPTION\n')
    f.write(':---|:---\n')
    for i in data.index:
        f.write(f'{i}|{data[i]}\n')

