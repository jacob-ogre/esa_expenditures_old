# Use the unified naming data to clean up the 2001-2007 expenditures data.
# Copyright (C) 2015 Defenders of Wildlife, jmalcom@defenders.org

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, see <http://www.gnu.org/licenses/>.

import sys



def main():
    """
    Use the unified naming data to clean up the 2001-2007 expenditures data.
    
    USAGE
        python clean_2001-2007_expend_data.py <infile> <lookup> <misses> <outfil>
    ARGS
        infile, path to a tab'd file of 2001-2007 EndSp expenditure data
        lookup, path to a tab'd file of standardized common, scientific names
        misses, path to a tab'd output file of 2001-2007 names missed in lookup
        outfil, path to a tab'd output file of 2001-2007 EndSp expenditure data
    """
    name_ref = load_ref_table()
    process_infile(name_ref)

def load_ref_table():
    ""
    pass

def process_infile(ref):
    ""
    pass

if __name__ == '__main__':
    if len(sys.argv) != 5:
        print main.__doc__
        sys.exit()
    infile = sys.argv[1]
    lookup = sys.argv[2]
    misses = sys.argv[3]
    outfil = sys.argv[4]
    main()
