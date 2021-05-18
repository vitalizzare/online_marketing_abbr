#!/usr/bin/env python

import pandas as pd
import sys

try:
    abbr_file = 'abbr.csv' if len(sys.argv) == 1 else sys.argv[1]
    readme_file = 'README.md' if len(sys.argv) <= 2 else sys.argv[2]
    
    data = pd.read_csv(abbr_file, index_col=0, header=None, squeeze=True)
    
    data = data.sort_index()
    with open(readme_file, 'w') as f:
        f.write('ABBR|DESCRIPTION\n'
                ':---|:---\n')
        for i in data.index:
            f.write(f'{i}|{data[i]}\n')
except Exception as e:
    print(repr(e), file=sys.stderr)
    sys.exit(1)
else:
    sys.exit(0)
