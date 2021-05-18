#!/usr/bin/env python

import pandas as pd
import sys
import os

how_to_use = f'''\
{sys.argv[0]} -h | --help | -?
{sys.argv[0]} [readme_file] [abbr_file]

    Read acronyms from abbr_file, sort them by name
    and write as a md-table into readme_file.
    By default it will look for abbr.csv as abbr_file
    and use README.md as readme_file.
'''

try:
    if sys.argv[-1] in ['-h', '--help', '-?']:
        print(how_to_use)
        raise UserWarning('Usage requested')
    readme_file = 'README.md' if len(sys.argv) == 1 else sys.argv[1]
    abbr_file = 'abbr.csv' if len(sys.argv) <= 2 else sys.argv[2]
    readme_file_new = readme_file + '.new'
    if not abbr_file in next(iter(os.walk('.')))[-1]:
        raise ValueError(f"Input file {abbr_file} doesn't exist")
    if abbr_file == readme_file:
        raise ValueError('Equal input and output file names passed')
    
    data = pd.read_csv(abbr_file, index_col=0, header=None, squeeze=True)
    
    data = data.sort_index()
    with open(readme_file_new, 'w') as f:
        f.write('ABBR|DESCRIPTION\n'
                ':---|:---\n')
        for i in data.index:
            f.write(f'{i}|{data[i]}\n')
except UserWarning:
    sys.exit(103)
except Exception as e:
    # delete readme_file_new if any
    try:
        os.system(f"[ -f '{readme_file_new}' ] && rm '{readme_file_new}'")
    except NameError:
        pass
    print(repr(e), file=sys.stderr)
    if type(e) is ValueError:
        sys.exit(102)
    else:
        sys.exit(101)
else:
    # move readme_file_new -> readme_file
    os.system(f"mv '{readme_file_new}' '{readme_file}'")
    sys.exit(0)
    
